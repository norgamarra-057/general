#!/bin/bash

#
# URL: https://confluence.groupondev.com/display/RED/Cloud+FAQ#CloudFAQ-HowmuchmemorydoesElasticacheactuallygivefordatastorage
#
if (($# == 0));
then
cat <<EOT

# Usage:
#<scriptname>             <cluster>  <db type>   <region>    <memory in GiB>

./ec_node_recommender.sh   cluster   redis        us-west-1   100
./ec_node_recommender.sh   single    redis        us-west-1   100
./ec_node_recommender.sh   single    memcached    eu-west-1   160
./ec_node_recommender.sh   cluster   memcached    eu-west-1   160

EOT
exit 1
fi


cluster=$1
dbtype=$2
region=$3
memory=$4


hours=12
vnow=`date +%s`;

if  [ ! -f ref.db ]; then
  ./refresh.sh
  echo "Index Updated..."
else
  filemodified=`date -r ref.db +%s`;
  count_hours=$((($vnow-$filemodified)/3600));
  if [ $count_hours -gt $hours ]
  then
  ./refresh.sh
  echo "Index Updated..."
  fi
fi



if [ "$dbtype" == "memcached" ];
then

if [ "$cluster" == "single" ];
then
  sql_where_condition1="and s.seq_no=1"
else
  sql_where_condition1="and s.seq_no>1"
fi

var=`echo "$memory < 1" | bc`
if ((var == 0));
then
  sql_where_condition2="and ((s.seq_no*m.MemorySizeGiB)-(s.seq_no*0.1)) between ${memory}*1.00 and ${memory}*5"
else
  sql_where_condition2="and ((s.seq_no*m.MemorySizeGiB)-(s.seq_no*0.1)) between ${memory}*1.00 and ${memory}*10"
fi


sqlite3 ref.db <<EOT

select ' ' as '';
select aws_region as '' from MemcachedNodes where aws_region_code='${region}' limit 1;
select ' ' as '';

.header on
.separator "\t"
.mode column
.nullvalue NULL

select distinct
--m.aws_region_code,
--m.aws_region as "aws_region              ",
m.node_type as "node_type         ",
s.seq_no No_of_nodes,
m.vcpu "Vcpu/node",
--s.seq_no*m.vcpu AggVcpu,
m.MemorySizeGiB "MemoryGiB/node",
printf("%.3f",m.priceUSD) as "$/node/h",
printf("%.2f",(((s.seq_no*m.MemorySizeGiB)-(s.seq_no*0.1)))) AllocableMemoryGiB,
cast(((s.seq_no*m.priceUSD*24*30)) as int) "$/month (without rep)",
cast((2*(s.seq_no*m.priceUSD*24*30)) as int) "$/month (with rep)"
from MemcachedNodes m, sequence s
where m.aws_region_code='${region}'
${sql_where_condition2}
${sql_where_condition1}
and m.node_type not like 'cache.t2.%'
and m.node_type not like 'cache.m4.%'
and m.node_type not like 'cache.r4.%'
order by ("$/month (with rep)"-("$/month (with rep)"%100)) asc,(s.seq_no/m.vcpu) desc
limit 20;
EOT
fi


if [ "$dbtype" == "redis" ];
then

if [ "$cluster" == "single" ];
then
  sql_where_condition1="and s.seq_no=1"
else
  sql_where_condition1="and s.seq_no>1"
fi

var=`echo "$memory < 1" | bc`
if ((var == 0));
then
  sql_where_condition2="and ((s.seq_no*r.MemorySizeGiB*0.75)) between ${memory}*1.00 and ${memory}*5"
else
  sql_where_condition2="and ((s.seq_no*r.MemorySizeGiB*0.75)) between ${memory}*1.00 and ${memory}*10"
fi


sqlite3 ref.db <<EOT

select ' ' as '';
select aws_region as '' from MemcachedNodes where aws_region_code='${region}' limit 1;
select ' ' as '';

.header on
.separator "\t"
.mode column
.nullvalue NULL

select distinct
--r.aws_region_code,
--r.aws_region as "aws_region              ",
r.node_type as "node_type         ",
s.seq_no No_of_nodes,
r.vcpu "Vcpu/node",
--s.seq_no*r.vcpu AggVcpu,
r.MemorySizeGiB "MemoryGiB/node",
printf("%.3f",r.priceUSD) as "$/node/h",
printf("%.2f",(s.seq_no*r.MemorySizeGiB*0.75)) AllocableMemoryGiB,
cast(((s.seq_no*r.priceUSD*24*30)) as int) "$/month (without rep)",
cast((2*(s.seq_no*r.priceUSD*24*30)) as int) "$/month (with rep)"
from RedisNodes r, sequence s
where r.aws_region_code='${region}'
${sql_where_condition2}
${sql_where_condition1}
and r.node_type not like 'cache.t2.%'
and r.node_type not like 'cache.m4.%'
and r.node_type not like 'cache.r4.%'
order by ("$/month (with rep)"-("$/month (with rep)"%100)) asc,(s.seq_no/r.vcpu) desc
limit 20;

EOT

fi

