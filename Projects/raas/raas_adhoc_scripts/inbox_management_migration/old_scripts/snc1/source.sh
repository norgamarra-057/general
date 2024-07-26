# export PATH="/home/ksatyamurthy/redis-6.0.5/bin/:$PATH"

function check_replication() {
# Host: raas-pool10.snc1
# Port: 6379
# check_replication raas-pool10.snc1 6379

random="$RANDOM$RANDOM"

while true;
do
    slave_cnt=`redis-cli -h $1 -p $2 info replication | grep -c 'role:slave'`
    link_complete_cnt=`redis-cli -h $1 -p $2 info replication | grep -c 'master_link_status:up'`

    source_hostname=`redis-cli -h $1 -p $2 info replication | grep master_host | awk -F: '{ print $2 }' | tr -d '\r'`
    source_port=`redis-cli -h $1 -p $2 info replication | grep master_port | awk -F: '{ print $2 }' | tr -d '\r'`

    redis-cli -h $1 -p $2 info keyspace > target_${random}.txt 
    redis-cli -h $source_hostname -p $source_port info keyspace > source_${random}.txt 
    diffvalue=`diff source_${random}.txt target_${random}.txt | wc -l `

    if [ "$slave_cnt" -eq 1 ] && [ "$link_complete_cnt" -eq 1 ] && [ "$diffvalue" -eq 0 ]; then 
        echo "Replication completed successfully on $1 $2"
        rm -f source_${random}.txt target_${random}.txt
        break;
    fi;
    echo "Waiting..."
    sleep 60
done 
}


function setup_cascade_server() {
source_server="$1"       # im-redis-node-slave1.snc1
source_port="$2"         # 6379
cascade_server="$3"      # raas-pool10.snc1
cascade_port="$4"        # 6379, 6380
redis-cli -h $cascade_server -p $cascade_port flushall
sleep 10
redis-cli -h $cascade_server -p $cascade_port replicaof $source_server $source_port
echo "Replication status check..."
# Wait until the replication completes
check_replication $cascade_server $cascade_port
}
