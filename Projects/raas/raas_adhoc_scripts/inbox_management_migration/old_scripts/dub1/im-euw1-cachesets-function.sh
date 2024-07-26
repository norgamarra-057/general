
# 373594 keys
copy_to_aws_with_swap im-redis-node1.snc1 6393 1 inbox-mgmt-cmpaignmetrics




copy_to_aws_with_swap () 
{ 

if [[ $# -ne 4 ]]; 
then
echo "
# Usage:

copy_to_aws_with_swap im-redis-node6.dub1 6397 3 inbox-mgmt-mobile-cmpaigncntxt

"
return 
fi

source_host=$1
source_port=$2
swapdb=$3
target_host=${4}--redis.prod.prod.eu-west-1.aws.groupondev.com

random_no=$RANDOM

echo "${source_host} ${source_port} ${swapdb} ${target_host}"

echo "redis-cli -h $source_host -p $source_port --rdb redis_source_data${random_no}.rdb"
redis-cli -h $source_host -p $source_port --rdb redis_source_data${random_no}.rdb

echo "rdb --command protocol  redis_source_data${random_no}.rdb | redis-cli -h $target_host -p 6379 --pipe"
rdb --command protocol  redis_source_data${random_no}.rdb | redis-cli -h $target_host -p 6379 --pipe

cat <<EOT | redis-cli -h $target_host -p 6379
select 0
flushdb
EOT

sleep 5

cat <<EOT | redis-cli -h $target_host -p 6379
select $swapdb
swapdb $swapdb 0
EOT

rm -vf redis_source_data${random_no}.rdb

for x in `redis-cli -h $target_host -p 6379 info keyspace | sed '1d' | grep -v 'db0:keys=' | awk -F: '{ print $1 }'  | sed -e 's/db//'`
do
cat <<EOT | redis-cli -h $target_host -p 6379
select $x
flushdb
EOT
done


echo 
echo "#Source:"
echo -e "\t`redis-cli -h $source_host -p $source_port info keyspace | sed '1d'`"
echo "#Target:"
echo -e "\t`redis-cli -h $target_host -p 6379         info keyspace | sed '1d'`"

}


