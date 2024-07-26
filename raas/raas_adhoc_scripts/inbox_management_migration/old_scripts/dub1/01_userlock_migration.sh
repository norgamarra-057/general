#!/bin/bash

# JIRA : RAAS-143

exit 0

ssh raas-pool10.dub1

redis-cli -h im-redis-node-slave1.dub1 -p 6379 --rdb email-users01.rdb
echo "export completed"
rdb --command protocol  ./email-users01.rdb | redis-cli -h inbox-mgmt-email-prod-users01--redis.prod.prod.eu-west-1.aws.groupondev.com -p 6379 --pipe



redis-cli -h im-redis-node-slave7.dub1 -p 6379 --rdb mobile-users01.rdb
echo "export completed"
rdb --command protocol  ./mobile-users01.rdb | redis-cli -h inbox-mgmt-mobile-prod-users01--redis.prod.prod.eu-west-1.aws.groupondev.com -p 6379 --pipe
redis-cli -h inbox-mgmt-mobile-prod-users01--redis.prod.prod.eu-west-1.aws.groupondev.com -p 6379 swapdb 2 0




email_user_lock_data_copy() {

sno=`printf "%02d" $1`
source_no=$2
source_port=$3
target_no=`printf "%02d" $4`

cat <<EOT | bash -vx 
date
redis-cli -h im-redis-node-slave${source_no}.dub1 -p $source_port --rdb email-users${sno}.rdb
date
echo "Export completed"
rdb --command protocol  ./email-users${sno}.rdb | redis-cli -h inbox-mgmt-email-prod-users${target_no}--redis.prod.prod.eu-west-1.aws.groupondev.com -p 6379 --pipe
date
EOT

}


mobile_user_lock_data_copy() {

sno=`printf "%02d" $1`
source_no=$2
source_port=$3
target_no=`printf "%02d" $4`

cat <<EOT | bash -vx 
date
redis-cli -h im-redis-node-slave${source_no}.dub1 -p $source_port --rdb mobile-users${sno}.rdb
date
echo "Export completed"
rdb --command protocol  ./mobile-users${sno}.rdb | redis-cli -h inbox-mgmt-mobile-prod-users${target_no}--redis.prod.prod.eu-west-1.aws.groupondev.com -p 6379 --pipe
redis-cli -h inbox-mgmt-mobile-prod-users${target_no}--redis.prod.prod.eu-west-1.aws.groupondev.com -p 6379 swapdb 2 0
date
EOT
	
}

