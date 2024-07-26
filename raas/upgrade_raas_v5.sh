#!/bin/bash

# Usage: upgrade.sh <cluster-name> <host-class> <GPROD-ticket>
# Example:
# ./upgrade.sh dub1.raas-watson-eventstore-tier1-prod.grpn redislabs5-2017.12.05_21.16 GPROD-73288 2>&1 | tee dub1.raas-watson-eventstore-tier1-prod.grpn.log
#
# This script helps in upgrade to Redis version 5

set -vx
set -e
set -u
set -o pipefail
trap 'exit 8' ERR

cluster=$1
hostclass=$2
gprod=$3
ops_config="/home/ksatyamurthy/github_projects/ops-config"

echo "cluster: $cluster"
echo "hostclass: $hostclass"
echo "gprod: $gprod"


master=`ssh $cluster "sudo rladmin status nodes" | grep raas | grep master | awk '{ print $4"."substr($9,0,3)"1" }' | tr 'A-Z' 'a-z'`
slaves=`ssh $cluster "sudo rladmin status nodes" | grep raas | grep slave | awk '{ print $4"."substr($9,0,3)"1" }' | tr 'A-Z' 'a-z' | tr '\n' ' ' | sed -e 's/ $//'`

for i in $master $slaves
do
ssh $i 'echo Hello `hostname -f`'
done

cd $ops_config
git pull
bin/set_hostclass $hostclass hosts/${master}.yml
for i in $slaves
do
bin/set_hostclass $hostclass hosts/${i}.yml
done
git add hosts/${master}.yml
for i in $slaves
do
git add hosts/${i}.yml
done
git diff
git commit -m "${gprod} upgrade to 5.0"
bin/ops-config-queue
bin/ready_to_roll ${master} ${slaves}

[ -f ./size_of_ccs.txt ] && rm -f size_of_ccs.txt

for i in $master $slaves
do
check_quorum=`echo $i | grep quorum || true  | wc -l`
if [[ $check_quorum -eq 0 ]]
then
    count=`ssh $i "find /var/groupon/redislabs/persist/ccs/ -mmin -10 -type f -name 'ccs-redis.rdb'" | wc -l`

    # no more than 10% diff ?
    if [[ $count -ne 1 ]]
    then
      echo "Backup file ccs-redis.rdb not found on ${i}"
      exit 8
    fi
    ssh $i "du /var/groupon/redislabs/persist/ccs/ccs-redis.rdb" | awk '{ print $1 }' >>size_of_ccs.txt
fi
done


mins=`cat size_of_ccs.txt | sort -n | head -1 `
maxs=`cat size_of_ccs.txt | sort -n | tail -1 `

tvalue=`echo "($maxs/$mins) < 1.1" | bc -l`

if ! [[ $tvalue -eq 1 ]] # size of the file, (max/min) < 1.1 continue,  else exit 8
then
  echo "Backup file ccs-redis.rdb size is inconsistent."
  exit 8
fi

#ssh $cluster "sudo rladmin tune cluster watchdog_profile cloud"

shards_no=`ssh $cluster "sudo rladmin status shards extra all" | grep "^db:" | wc -l`
shards_ok=`ssh $cluster "sudo rladmin status shards extra all" | grep "^db:" | grep "OK" | wc -l`
shards_na=`ssh $cluster "sudo rladmin status shards extra all" | grep "^db:" | grep "N/A" | wc -l`

if ! [[ $shards_no -eq $shards_ok && $shards_no -eq $shards_na ]]
then
  echo "Shards not ok, to debug run: sudo rladmin status shards extra all"
  exit 8
fi

dbs_no=`ssh $cluster "sudo rladmin status databases extra all" | grep "^db:" | wc -l`
dbs_na=`ssh $cluster "sudo rladmin status databases extra all" | grep "^db:" | grep -o "N/A" | wc -l`

if ! [[ $dbs_no -eq $((dbs_na / 4)) ]]
then
  echo "DBs not ok, to debug run: sudo rladmin status databases extra all"
  exit 8
fi


for i in $master $slaves
do
ssh $i 'set -euo pipefail;trap "exit 8" ERR;touch /tmp/force_redislabs_install;sudo /var/tmp/roll;sleep 10; sudo rlcheck|grep "ALL TESTS PASSED" && sudo rladmin status extra all|grep node:|grep -v OK || echo ALL_OK; sleep 10'
done
ssh $cluster "set -euo pipefail;trap 'exit 8' ERR;for d in \$(sudo rladmin status databases|grep db:|awk '{print \$2}'); do echo upgrading db \$d; sudo rladmin upgrade db \$d; sleep 5; done"
