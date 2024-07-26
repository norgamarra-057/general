#!/bin/bash

# It is desgined to run from local MAC laptop
# JIRA : RAAS-143

# Source 
# # # # #
# hostname: im-redis-node-slave1.snc1
# port: 6379 


source ./source.sh

cascade_server="raas-pool10.snc1"
cascade_server_ip=`host $cascade_server | awk '{ print $4 }'`
source_server="im-redis-node-slave7.snc1"
source_port="6380"
port1=`echo "10000 + $source_port" | bc`     # 36380   DB0
port2=`echo "20000 + $source_port" | bc`     # 46380   DB2
target_db="users26"

# Cascade
# # # # #
scp ./redis-*.conf $cascade_server:
#scp ./start-redis-server.sh $cascade_server:
username=`whoami`
#ssh $cascade_server "bash -vx /home/$username/start-redis-server.sh"

ssh $cascade_server "/home/ksatyamurthy/redis-6.0.5/bin/redis-cli -p ${port1} shutdown nosave"
ssh $cascade_server "/home/ksatyamurthy/redis-6.0.5/bin/redis-cli -p ${port2} shutdown nosave"
ssh $cascade_server "sudo rm -vf /var/groupon/redis/${port1}/*.rdb"
ssh $cascade_server "sudo rm -vf /var/groupon/redis/${port2}/*.rdb"
ssh $cascade_server "sudo /home/ksatyamurthy/redis-6.0.5/bin/redis-server /home/ksatyamurthy/redis-${port1}.conf  &"
ssh $cascade_server "sudo /home/ksatyamurthy/redis-6.0.5/bin/redis-server /home/ksatyamurthy/redis-${port2}.conf  &"

echo "Waiting for service to start..."
sleep 30

echo "setup_cascade_server $source_server $source_port $cascade_server $port1"
sleep 20
setup_cascade_server $source_server $source_port $cascade_server $port1

cat <<EOL | redis-cli -h $cascade_server -p $port1 
replicaof no one
select 2
flushdb 
EOL
sleep 20

aws-okta exec prd -- aws --no-cli-pager --region us-west-1 elasticache start-migration --replication-group-id "inbox-mgmt-email-prod-${target_db}-prod" --customer-node-endpoint-list "Address='$cascade_server_ip',Port=$port1"



echo "setup_cascade_server $source_server $source_port $cascade_server $port2"
sleep 20
setup_cascade_server $source_server $source_port $cascade_server $port2

cat <<EOL | redis-cli -h $cascade_server -p $port2
replicaof no one
select 0
flushdb 
swapdb 2 0
EOL


sleep 20
aws-okta exec prd -- aws --no-cli-pager --region us-west-1 elasticache start-migration --replication-group-id "inbox-mgmt-mobile-prod-${target_db}-prod" --customer-node-endpoint-list "Address='$cascade_server_ip',Port=$port2"



sleep 20
check_replication inbox-mgmt-email-prod-${target_db}--redis.prod.prod.us-west-1.aws.groupondev.com 6379
sleep 60
aws-okta exec prd -- aws --no-cli-pager --region us-west-1 elasticache complete-migration --replication-group-id  "inbox-mgmt-email-prod-${target_db}-prod"
sleep 60
redis-cli -h $cascade_server -p $port1 info keyspace 
redis-cli -h inbox-mgmt-email-prod-${target_db}--redis.prod.prod.us-west-1.aws.groupondev.com -p 6379 info keyspace 
sleep 10
#redis-cli -h $cascade_server -p $port1 shutdown nosave

check_replication inbox-mgmt-mobile-prod-${target_db}--redis.prod.prod.us-west-1.aws.groupondev.com 6379
sleep 60
aws-okta exec prd -- aws --no-cli-pager --region us-west-1 elasticache complete-migration --replication-group-id "inbox-mgmt-mobile-prod-${target_db}-prod"
sleep 60
redis-cli -h $cascade_server -p $port2 info keyspace 
redis-cli -h inbox-mgmt-mobile-prod-${target_db}--redis.prod.prod.us-west-1.aws.groupondev.com -p 6379 info keyspace 
sleep 10
#redis-cli -h $cascade_server -p $port2 shutdown nosave

# check the link master link status is up & then the no of keys look ok ?.
# Stop the replication 

cat <<EOL
# To STOP the replication, run the following commands:
#         #          #         #        #

redis-cli -h raas-pool10.snc1 -p 6379 info keyspace 
redis-cli -h inbox-mgmt-email-prod-${target_db}--redis.prod.prod.us-west-1.aws.groupondev.com -p 6379 info keyspace 
redis-cli -h raas-pool10.snc1 -p 6380 info keyspace 
redis-cli -h inbox-mgmt-mobile-prod-${target_db}--redis.prod.prod.us-west-1.aws.groupondev.com -p 6379 info keyspace 

####
aws-okta exec prd -- aws --no-cli-pager --region us-west-1 elasticache complete-migration --replication-group-id  "inbox-mgmt-email-prod-${target_db}-prod"
aws-okta exec prd -- aws --no-cli-pager --region us-west-1 elasticache complete-migration --replication-group-id "inbox-mgmt-mobile-prod-${target_db}-prod"

sleep 120
redis-cli -h $cascade_server -p $port1 shutdown nosave
redis-cli -h $cascade_server -p $port2 shutdown nosave
EOL



