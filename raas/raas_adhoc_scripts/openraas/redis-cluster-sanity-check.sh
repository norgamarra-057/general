#
#
# Example:
# ./redis-cluster-sanity-check.sh snc1 badges.os.prd.snc1.raas.grpn 10024
#
# Output:
# ---------
#  The below list of shards have both PRIMARY & REPLICA on the same NODE.
# commands
# redis-cli --cluster del-node 10.22.215.20:10030 454a2a9a6bcca50464f1ea68bff07ccc86b24220 redis-cli --cluster add-node 10.22.215.20:10030 $SEED_CONNECTION --cluster-slave --cluster-master-id <master>
# redis-cli --cluster del-node 10.22.215.20:10031 7b107f65e18bde307e31926cb113f5e8134db8f7 redis-cli --cluster add-node 10.22.215.20:10031 $SEED_CONNECTION --cluster-slave --cluster-master-id <master>
# redis-cli --cluster del-node 10.22.215.21:10032 0579e5d66f30df94f62dc3d58057928995c5ef93 redis-cli --cluster add-node 10.22.215.21:10032 $SEED_CONNECTION --cluster-slave --cluster-master-id <master>
# redis-cli --cluster del-node 10.22.215.21:10033 d4a9a80282ddf0a68bf2865053890d8073f189ff redis-cli --cluster add-node 10.22.215.21:10033 $SEED_CONNECTION --cluster-slave --cluster-master-id <master>
# redis-cli --cluster del-node 10.22.215.22:10034 5e0e3c8c200c529de8f26d9e482473dc145c4338 redis-cli --cluster add-node 10.22.215.22:10034 $SEED_CONNECTION --cluster-slave --cluster-master-id <master>
# redis-cli --cluster del-node 10.22.215.22:10035 f9b6ff4a1fc9b44eb813c6dbd36cb86919bf5130 redis-cli --cluster add-node 10.22.215.22:10035 $SEED_CONNECTION --cluster-slave --cluster-master-id <master>


COLO=$1             # "snc1"
HOSTNAME=$2             # "badges.os.prd.snc1.raas.grpn"
PORT=$3             # "10024"



ssh raas-os1.$COLO "redis-cli -h $HOSTNAME -p $PORT cluster nodes | grep master " > badges_sac1_master.txt
echo "id,ip,port1,port2,role,dash,some,num,num2,status,slots" > badges_sac1_master.csv
sed -e 's/myself,//' -e 's/:/ /' -e 's/@/ /' -e 's/ /,/g' -e 's/,,/,/g'  < badges_sac1_master.txt >> badges_sac1_master.csv


sqlite3 cnodes.db <<EOT
.mode csv
.import badges_sac1_master.csv tab1m

.header on 
.separator "\t"
--select * from tab1m;

EOT




ssh raas-os1.$COLO "redis-cli -h $HOSTNAME -p $PORT cluster nodes | grep slave " > badges_sac1_slave.txt
echo "id,ip,port1,port2,role,master,some,num,num2,status" > badges_sac1_slave.csv
sed -e 's/myself//' -e 's/:/ /' -e 's/@/ /' -e 's/ /,/g'  < badges_sac1_slave.txt >> badges_sac1_slave.csv


sqlite3 cnodes.db <<EOT
.mode csv
.import badges_sac1_slave.csv tab1s

.header on 
.separator "\t"
--select * from tab1s;

EOT

echo ""
echo " The below list of shards have both PRIMARY & REPLICA on the same NODE. "
echo ""

sqlite3 cnodes.db <<EOT

.header on 
.separator "\t"

--select a.id,a.slots,a.ip as master_ip,a.port1,a.port2,b.ip as slave_ip,b.port1,b.port2 from tab1m a, tab1s b where a.id=b.master and a.ip=b.ip;

select 'redis-cli --cluster del-node '||b.ip||':'||b.port1||' '||b.id||'# '||a.id ||' redis-cli --cluster add-node '||b.ip||':'||b.port1||' \$SEED_CONNECTION --cluster-slave --cluster-master-id <master>'  as commands
from tab1m a, tab1s b where a.id=b.master and a.ip=b.ip
order by b.ip,b.port1;

EOT

rm -f cnodes.db badges_sac1_slave.csv badges_sac1_master.csv badges_sac1_master.txt badges_sac1_slave.txt
