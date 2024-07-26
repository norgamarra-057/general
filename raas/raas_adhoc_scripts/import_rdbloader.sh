# Reverse copy
SOURCE_CLUSTER="sac1.raas-shared3-prod.grpn"
TARGET_CLUSTER="sac1.raas-dealcatalog-prod.grpn"
TARGET_ENDPOINT="redis-13000.sac1.raas-dealcatalog-prod.grpn"

# Forward copy
SOURCE_CLUSTER="sac1.raas-dealcatalog-prod.grpn"
TARGET_CLUSTER="sac1.raas-shared3-prod.grpn"
TARGET_ENDPOINT="redis-13099.sac1.raas-shared3-prod.grpn"


{
ssh  $SOURCE_CLUSTER "sudo rladmin status shards | grep dealservice-shield | grep slave" > source.tsv
sed -E 's/ +/,/g' source.tsv | sed 's/,$//' > source.csv 

ssh $TARGET_CLUSTER "sudo rladmin status shards | grep dealservice-shield | grep master" > target.tsv
sed -E 's/ +/,/g' target.tsv | sed 's/,$//' > target.csv 


ssh $SOURCE_CLUSTER "sudo rladmin status nodes | sed '1,2d' " > snodes.tsv
sed -E 's/ +/,/g' snodes.tsv | sed 's/,$//' | tr -d '*' > snodes.csv 

ssh $TARGET_CLUSTER "sudo rladmin status nodes | sed '1,2d' " > tnodes.tsv
sed -E 's/ +/,/g' tnodes.tsv | sed 's/,$//' | tr -d '*' > tnodes.csv 
}

# Flushall 
for h in `redis-cli -h $TARGET_ENDPOINT -p 13099 cluster nodes  | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'`; do echo $h; redis-cli -c -h $h -p 13099 flushall; done


rm -vf dss.db

sqlite3 dss.db <<EOT
drop table if exists source;
CREATE TABLE source (
DBID text,
NAME text,
ID text,
NODE text,
ROLE text,
SLOTS text,
USED_MEMORY text,
STATUS text
);

drop table if exists target;
CREATE TABLE target (
DBID text,
NAME text,
ID text,
NODE text,
ROLE text,
SLOTS text,
USED_MEMORY text,
STATUS text
);

.separator ","
.import source.csv source
.import target.csv target

--select s.ID, from source s join target t on s.SLOTS=t.SLOTS;
.header on 
drop table if exists snodes;
create table snodes(
NODEID TEXT,
ROLE TEXT,
ADDRESS TEXT,
HOSTNAME TEXT,
SHARDS TEXT,
CORES TEXT,
FREE_RAM TEXT,
PROVISIONAL_RAM TEXT,
VERSION TEXT,
RACKID TEXT,
STATUS TEXT);

drop table if exists tnodes;
create table tnodes(
NODEID TEXT,
ROLE TEXT,
ADDRESS TEXT,
HOSTNAME TEXT,
SHARDS TEXT,
CORES TEXT,
FREE_RAM TEXT,
PROVISIONAL_RAM TEXT,
VERSION TEXT,
RACKID TEXT,
STATUS TEXT);

.separator ","
.import snodes.csv snodes
.import tnodes.csv tnodes

select cmd_part1 || ' "cd /var/groupon/raas/; '  || group_concat(cmd_part2,';') || '"'
from (
select 'ssh ' || TargetHostname cmd_part1, ' wget -N http://' || SourceHostname || ':12222/' || shardid || '.rdb ' cmd_part2
from (
select tn.hostname || '.' || lower(substr(tn.RACKID,0,5)) TargetHostname,sn.hostname || '.' || lower(substr(sn.RACKID,0,5)) SourceHostname, replace(s.ID,':','-') shardid
from source s
join target t on s.SLOTS=t.SLOTS
join snodes sn on s.NODE=sn.NODEID
join tnodes tn on t.NODE=tn.NODEID) a) a1
group by cmd_part1
order by cmd_part1
;

select cmd_part1 || ' "cd /var/groupon/raas/; '  || group_concat(cmd_part2,';') || '"'
from (
select 'ssh ' || TargetHostname cmd_part1 , ' sudo rl_rdbloader ' || shardid || '.rdb --action load --addr ' || TargetHostname || '  --port 13099' cmd_part2
from (
select tn.hostname || '.' || lower(substr(tn.RACKID,0,5)) TargetHostname,sn.hostname || '.' || lower(substr(sn.RACKID,0,5)) SourceHostname, replace(s.ID,':','-') shardid
from source s
join target t on s.SLOTS=t.SLOTS
join snodes sn on s.NODE=sn.NODEID
join tnodes tn on t.NODE=tn.NODEID) a) a1
group by cmd_part1
order by cmd_part1
;

EOT



# Keyspace
for h in `redis-cli -h $TARGET_ENDPOINT -p 13099 cluster nodes  | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'`; do echo $h; redis-cli -c -h $h -p 13099 info keyspace; done



