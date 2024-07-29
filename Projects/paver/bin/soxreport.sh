#!/usr/bin/env bash

# generate sox report from dev1.snc1
# no arguments needed.  At the moment just adjust the below vars as needed
# you will NEED to adjust at least the following:
# OPS_CONFIG_DIR on dev1.snc1 (local) box.
#  PAVER_DIR
#  SOX_WORK_DIR
# you must make sure your paver repo is up to date 


### definitions as defaults
RESULTS_DB=sox_results.db
SOX_HOSTS_LIST=soxhostlist.orig
SOX_HOSTS_LIST_RESOLVED=soxhostlist_resolved.csv
SOX_DB_LIST=soxdblist.orig
SOX_DB_LIST_RESOLVED=soxdblist_resolved.csv
SOX_ACL_LIST_FULL=sox_full_acl_list.csv
SOX_INSTANCE_INFO_RESOLVED=sox_instance_info_resolved.csv
VIP_RESOLVED=vip_resolved.csv
FW_ACCESS_LIST_FULL=fw_access_list_full.csv
ACCESS_HOSTS_RESOLVED=access_hosts_resolved.csv

### get cli args
OPTIND=1

OPS_CONFIG_DIR=~/repos/ops-config
PAVER_DIR=~/repos/paver
SOX_WORK_DIR=~/my_sox_2017Q1

while getopts "hops:" opt; do
  case "$opt" in
  h)
    echo "soxreport.sh generates a current SOX report."
    echo "Run from dev1.snc1 and make sure your ops-config and paver repos are up to date"
    echo "note - paver repo needs to be on gds-admin01.snc1"
    echo ""
    echo "USAGE:"
    echo "./soxreport.sh -o <ops-config-path> -p <paver-path> -s <sox-work-dir>"
    echo ""
    echo "  -o points to ops-config git repo directory locally on dev1.snc1"
    echo "  -p points to the paver git repo directory remotely on gds-admin01.snc1"
    echo "  -s points to the working directory for generating the report."  
    echo "     The report will also be stored here."
    echo "  -h print this help"
    echo ""
    exit 1
    ;;
   o)
    OPS_CONFIG_DIR=$OPTARG
    ;;
   p)
    PAVER_DIR=$OPTARG
    ;;
   s)
    SOX_WORK_DIR=$OPTARG
    ;;
  esac
done



# prep
echo "PREPARING ENV"

mkdir $SOX_WORK_DIR
cd $SOX_WORK_DIR

if [ -f $RESULTS_DB ]; then
    rm -f $RESULTS_DB.old
    mv $RESULTS_DB $RESULTS_DB.old
    echo "backed up old $RESULTS_DB to $RESULTS_DB.old"
fi


echo "CREATE TABLE instances (cluster varchar(32), instance varchar(32), creation_ticket varchar(10), type char(10));" >> load_tables.sqlite
echo "CREATE TABLE db_vips (cluster varchar(32), instance varchar(32), rw_vip char(16), ro_vip char(16));" >> load_tables.sqlite
echo "CREATE TABLE vips (ip char(16), vip_name varchar(64));" >> load_tables.sqlite
echo "CREATE TABLE soxhosts (ip char(16), hostname varchar(64));" >> load_tables.sqlite
echo "CREATE TABLE access_hosts (ip char(16), hostname varchar(64));" >> load_tables.sqlite
echo "CREATE TABLE access_rules (cluster varchar(32), instance varchar(32), ip char(16), cidr int);" >> load_tables.sqlite
echo "CREATE TABLE access_live (cluster varchar(32), instance varchar(32), ip char(16), cidr int);" >> load_tables.sqlite
echo "CREATE TABLE violations (cluster varchar(32), instance varchar(32), type char(10), ip char(16), cidr int);" >> load_tables.sqlite

sqlite3 $RESULTS_DB < load_tables.sqlite


### acquire list of sox hosts
### Needs - hostname, ip, dc, owner / app

echo "SYNCING REPO"
cd $OPS_CONFIG_DIR
git pull > /dev/null

echo "ACQUIRING LIST OF SOX HOSTS FROM ops-config"
bin/check_sox_hosts printallsoxhosts > $SOX_WORK_DIR/$SOX_HOSTS_LIST


## resolve sox hosts
## store sox hosts and ip's
echo "RESOLVING SOX HOSTS"

cd $SOX_WORK_DIR

for h in `cat $SOX_HOSTS_LIST`
do
  host $h
  sleep 0.1
done | grep 'has address' | awk '{print $4, ",", $1}'  | sed 's/ //g' > $SOX_HOSTS_LIST_RESOLVED
echo ".mode csv" > load_hosts.sqlite
echo ".import $SOX_HOSTS_LIST_RESOLVED soxhosts" >> load_hosts.sqlite
sqlite3 $RESULTS_DB < load_hosts.sqlite

### acquire list of sox db's and underlying hosts
### Needs - cluster, instance name, type, RW Vip, RO Vip, ticket number?, team name / owner
## store sox db's
echo "ACQUIRING LIST OF SOX DBs"

ssh gds-admin01.snc1 "grep __SOX__ $PAVER_DIR/inventory/group_vars/gds*.yml" | awk '-Fgroup_vars/' '{print $2}' | cut -f 1-2 -d '#' | sed 's/.yml//g' | sed 's/\#//g' > $SOX_DB_LIST

for i in `cat $SOX_DB_LIST | while read -r line; do echo "$(echo -n "$line" | cut -f 1 -d ':').yml,$(echo -n "$line" | awk '{print $2}')"; done`
do
THEFILE=`echo $i | cut -f 1 -d ','`
THEDB=`echo $i | cut -f 2 -d ','`
THECLUSTER=`echo $i | cut -f 1 -d ',' | cut -f 1 -d '.'`
THEDB2=`echo $i | cut -f 2 -d ',' | cut -f 1 -d ':'`
echo -ne "$THECLUSTER,$THEDB2,"
ssh gds-admin01.snc1 cat $PAVER_DIR/inventory/group_vars/$THEFILE | grep -A1000 $THEDB | awk 'NR==1,/type:/' | grep -E "GDS-|type:" | sed 's/\#//' | awk '{print $2}' | tr '\n' ',' | sed 's/,,/,/g' | sed 's/,$//g'
echo ""
sleep 0.25
done > $SOX_INSTANCE_INFO_RESOLVED

echo ".mode csv" > load_instances.sqlite
echo ".import $SOX_INSTANCE_INFO_RESOLVED instances" >> load_instances.sqlite
sqlite3 $RESULTS_DB < load_instances.sqlite

# gather and populate info about the db instances and their associated vips
echo "RESOLVING INFO ABOUT SOX DBs"

for i in `cat $SOX_DB_LIST | while read -r line; do echo "$(echo -n "$line" | cut -f 1 -d ':').yml,$(echo -n "$line" | awk '{print $2}')"; done`
do
  THEFILE=`echo $i | cut -f 1 -d ','`
  THEDB=`echo $i | cut -f 2 -d ','`
  THECLUSTER=`echo $i | cut -f 1 -d ',' | cut -f 1 -d '.'`
  THEDB2=`echo $i | cut -f 2 -d ',' | cut -f 1 -d ':'`
  echo -ne "$THECLUSTER,$THEDB2,"
  ssh gds-admin01.snc1 cat $PAVER_DIR/inventory/group_vars/$THEFILE | grep -A100 $THEDB | grep -A10 master_vip | awk 'NR==1,/replication_ips:/' | grep -v 'slave_vips'| awk '{print $2}' | tr '\n' ',' | sed 's/,,/,/g' | sed 's/,$//g'
  echo ""
  sleep 0.25
done > $SOX_DB_LIST_RESOLVED

echo ".mode csv" > load_dbvips.sqlite
echo ".import $SOX_DB_LIST_RESOLVED db_vips" >> load_dbvips.sqlite
sqlite3 $RESULTS_DB < load_dbvips.sqlite

# gather and populate resolved vip information for db vips
echo "RESOLVING SOX VIP INFO"

for i in `cat $SOX_DB_LIST_RESOLVED | cut -f 3,4 -d ',' | sed 's/,/ /'`
do
  echo "$i,`host $i | awk '{print $5}' | sed 's/\.$//'`"
done > $VIP_RESOLVED

echo ".mode csv" > load_vips.sqlite
echo ".import $VIP_RESOLVED vips" >> load_vips.sqlite
sqlite3 $RESULTS_DB < load_vips.sqlite

### acquire list of whitelisted hosts for each instance
### Needs - hostname / NULL (range), ip, range cidr (or null)
## resolve hosts both directions to see if they still exist as those hosts
## remove any faulty ones and report
echo "ACQUIRING LIST OF PAVER DEFINED ACLS"

for i in `cat $SOX_DB_LIST | while read -r line; do echo "$(echo -n "$line" | cut -f 1 -d ':').yml,$(echo -n "$line" | awk '{print $2}')"; done`
do
  #echo "$i"
  THEFILE=`echo $i | cut -f 1 -d ','`
  THEDB=`echo $i | cut -f 2 -d ','`
  THECLUSTER=`echo $i | cut -f 1 -d ',' | cut -f 1 -d '.'`
  THEDB2=`echo $i | cut -f 2 -d ',' | cut -f 1 -d ':'`
  ssh gds-admin01.snc1 cat $PAVER_DIR/inventory/group_vars/$THEFILE | grep -A1000 $THEDB | grep -A1000 firewall_permitted | awk 'NR==1,/ports:/' | grep -v ':' | cut -f 1 -d '#' | awk '{print $2}' | sort -n | uniq > _TMP.$THECLUSTER.$THEDB2
  sleep 0.25
done

for i in `ls -1 _TMP.*`
do
  CLUSTER=`echo "$i" | cut -f 2 -d '.'`
  INSTANCE=`echo "$i" | cut -f 3 -d '.'`
  for j in `cat $i`
    do
    echo "$CLUSTER,$INSTANCE,$j" | sed 's/\//,/'
  done
done > $SOX_ACL_LIST_FULL

echo ".mode csv" > load_acls.sqlite
echo ".import $SOX_ACL_LIST_FULL access_rules" >> load_acls.sqlite
sqlite3 $RESULTS_DB < load_acls.sqlite



### acquire list of actually allowed hosts for each instance
### Needs - hostname/ NULL (range), ip, range cidr (or null)

echo "ACQUIRING ACTUALLY ALLOWED HOSTS FROM DB FIREWALLS"

for i in `cat $SOX_DB_LIST | while read -r line; do echo "$(echo -n "$line" | cut -f 1 -d ':').yml,$(echo -n "$line" | awk '{print $2}')"; done`
do
  #echo "$i"
  THEFILE=`echo $i | cut -f 1 -d ','`
  THEDB=`echo $i | cut -f 2 -d ',' | cut -f 1 -d ':'`
  THECLUSTER=`echo $i | cut -f 1 -d ',' | cut -f 1 -d '.'`
  THEDC=`echo $THECLUSTER | cut -f 2 -d '_'`
  THEHOST=`echo $THECLUSTER | sed 's/_/-/g'`m1.$THEDC
  THEDB2=`echo $i | cut -f 2 -d ',' | cut -f 1 -d ':'`
ssh -A gds-admin01.snc1 ssh -o StrictHostKeyChecking=no -o CheckHostIP=no $THEHOST cat /etc/pf.conf.d/tables/$THEDB-srcs.table | grep -A1000 Extra | grep -v '#' | sort -n | uniq > _TMPFW.$THECLUSTER.$THEDB
sleep 0.25
done

for i in `ls -1 _TMPFW.*`
do
  CLUSTER=`echo "$i" | cut -f 2 -d '.'`
  INSTANCE=`echo "$i" | cut -f 3 -d '.'`
  for j in `cat $i`
    do
    echo "$CLUSTER,$INSTANCE,$j" | sed 's/\//,/'
  done
done > $FW_ACCESS_LIST_FULL

echo ".mode csv" > load_fw.sqlite
echo ".import $FW_ACCESS_LIST_FULL access_live" >> load_fw.sqlite
sqlite3 $RESULTS_DB < load_fw.sqlite



### resolve the IP's from acl and fw and populate lookup table
# access_host table
echo "RESOLVING HOSTS ALLOWED BY DB FIREWALLS"

for h in `cat _TMP.* _TMPFW.* | cut -f 1 -d '/' | sort -n | uniq`
do
  host $h
  sleep 0.1
done | grep 'has address' | awk '{print $4, ",", $1}'  | sed 's/ //g' > $ACCESS_HOSTS_RESOLVED
echo ".mode csv" > load_access_hosts.sqlite
echo ".import $SOX_HOSTS_LIST_RESOLVED access_hosts" >> load_access_hosts.sqlite
sqlite3 $RESULTS_DB < load_access_hosts.sqlite

### run reports
### populate violations table
sqlite3 $RESULTS_DB "insert into violations select d.cluster, d.instance, d.type, r.ip, r.cidr from instances d inner join access_rules r on (d.cluster=r.cluster and d.instance=r.instance) left join soxhosts s on (r.ip=s.ip) where s.ip is null order by 1,2,3,4;"

echo -ne "Total violations:  "
sqlite3 $RESULTS_DB "select count(*) from violations;"
echo ""
echo -ne "Offending host count:  "
sqlite3 $RESULTS_DB "select count(distinct ip) from violations;"
echo ""
echo "Ranges present:  "
sqlite3 $RESULTS_DB "select cluster, instance, ip, cidr from violations where cidr <> 32 order by 2;"
echo ""
echo "Violations by cluster:  "
sqlite3 $RESULTS_DB "select cluster, instance, count(*) as ViolationCount from violations group by 1,2 order by 3 desc;"

echo ".mode csv" > gencsv.sqlite
echo "select * from violations;" >> gencsv.sqlite
sqlite3 $RESULTS_DB < gencsv.sqlite > sox_results.csv
echo "Full results saved as CSV in $SOX_WORK_DIR/sox_results.csv"


### cleanup
mkdir dbug
mv *.csv dbug/
mv *.sqlite dbug/
mv _TMP* dbug/
mv *.orig dbug/
cp dbug/sox_results.csv .
