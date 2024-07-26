
email_user_lock_data_copy() {

set -e
set -u
set -o pipefail

local sno=`printf "%02d" $1`
local source_no=$2
local source_port=$3
local target_no=`printf "%02d" $4`
var1="something"

cat <<EOT | bash -vx 
set -e
set -u
set -o pipefail

date
redis-cli -h im-redis-node-slave${source_no}.dub1 -p $source_port info keyspace | sed -e '1d'
if [ -f ./email-users${sno}.rdb ];then rm -vf ./email-users${sno}.rdb; fi;
redis-cli -h im-redis-node-slave${source_no}.dub1 -p $source_port --rdb email-users${sno}.rdb
date
echo "Export completed"
redis-cli -h inbox-mgmt-email-prod-users${target_no}--redis.prod.prod.eu-west-1.aws.groupondev.com -p 6379 info keyspace | sed -e '1d' 
var1=`redis-cli -h inbox-mgmt-email-prod-users${target_no}--redis.prod.prod.eu-west-1.aws.groupondev.com -p 6379 info keyspace | sed -e '1d' | wc -l`
if [ \$var1 -eq 0 ]; then 
    rdb --command protocol  ./email-users${sno}.rdb | redis-cli -h inbox-mgmt-email-prod-users${target_no}--redis.prod.prod.eu-west-1.aws.groupondev.com -p 6379 --pipe
    date
    rm -vf ./email-users${sno}.rdb
    redis-cli -h im-redis-node-slave${source_no}.dub1 -p $source_port info keyspace | sed -e '1d'
    redis-cli -h inbox-mgmt-email-prod-users${target_no}--redis.prod.prod.eu-west-1.aws.groupondev.com -p 6379 info keyspace | sed -e '1d' 
else 
    echo "inbox-mgmt-email-prod-users${target_no}--redis.prod.prod.eu-west-1.aws.groupondev.com"
fi;

EOT
set +e
set +u
set +o pipefail

}


mobile_user_lock_data_copy() {

set -e
set -u
set -o pipefail

local sno=`printf "%02d" $1`
local source_no=$2
local source_port=$3
local target_no=`printf "%02d" $4`
var1="something"

cat <<EOT | bash -vx 
set -e
set -u
set -o pipefail


date
redis-cli -h im-redis-node-slave${source_no}.dub1 -p $source_port info keyspace | sed -e '1d'
if [ -f ./mobile-users${sno}.rdb ];then rm -vf ./mobile-users${sno}.rdb; fi;
redis-cli -h im-redis-node-slave${source_no}.dub1 -p $source_port --rdb mobile-users${sno}.rdb
date
echo "Export completed"

redis-cli -h inbox-mgmt-mobile-prod-users${target_no}--redis.prod.prod.eu-west-1.aws.groupondev.com -p 6379 info keyspace | sed -e '1d'

var1=`redis-cli -h inbox-mgmt-mobile-prod-users${target_no}--redis.prod.prod.eu-west-1.aws.groupondev.com -p 6379 info keyspace | sed -e '1d' | wc -l`
if [ \$var1 -eq 0 ]; then 
    rdb --command protocol  ./mobile-users${sno}.rdb | redis-cli -h inbox-mgmt-mobile-prod-users${target_no}--redis.prod.prod.eu-west-1.aws.groupondev.com -p 6379 --pipe
    redis-cli -h inbox-mgmt-mobile-prod-users${target_no}--redis.prod.prod.eu-west-1.aws.groupondev.com -p 6379 swapdb 2 0
    date
    rm -vf ./mobile-users${sno}.rdb
    redis-cli -h im-redis-node-slave${source_no}.dub1 -p $source_port info keyspace | sed -e '1d'
    redis-cli -h inbox-mgmt-mobile-prod-users${target_no}--redis.prod.prod.eu-west-1.aws.groupondev.com -p 6379 info keyspace | sed -e '1d'
else
    echo "inbox-mgmt-mobile-prod-users${target_no}--redis.prod.prod.eu-west-1.aws.groupondev.com "
fi;

EOT
set +e
set +u
set +o pipefail

}
