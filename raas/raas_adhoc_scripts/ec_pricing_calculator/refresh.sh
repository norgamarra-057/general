#!/bin/bash

# print all available regions
#curl -sk https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonElastiCache/current/index.json \
#| jq '.products | .[] | .attributes.location' | sort | uniq | tr -d '"'


rm -vf index.json
wget https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonElastiCache/current/index.json > /dev/null 2>&1

     # csv file of instance types (redis)
echo "index_id,region,node_type,vcpu,MemorySizeGiB" > redis_node_type.csv
cat index.json \
| jq '.products | .[] | select ((.attributes.cacheEngine == "Redis") and (.attributes.locationType == "AWS Region") and (.attributes.currentGeneration == "Yes" )) | [.sku,.attributes.location,.attributes.instanceType,.attributes.vcpu,.attributes.memory] | @csv' | tr -d '\\"'  >> redis_node_type.csv
     # csv file of instance types (memcached)
echo "index_id,region,node_type,vcpu,MemorySizeGiB" > memcached_node_type.csv
cat index.json \
| jq '.products | .[] | select ((.attributes.cacheEngine == "Memcached") and (.attributes.locationType == "AWS Region") and (.attributes.currentGeneration == "Yes" )) | [.sku,.attributes.location,.attributes.instanceType,.attributes.vcpu,.attributes.memory] | @csv' | tr -d '\\"'  >> memcached_node_type.csv


# csv of instance cost info

echo "indexs,priceUSD" > node_price.csv
cat index.json \
| jq '.terms.OnDemand | .[] | .[] | .priceDimensions | .[] | [.rateCode,.pricePerUnit.USD] | @csv' | tr -d '\\"'  >> node_price.csv


echo "seq_no" > sequence.csv
seq 1 1 1000 >> sequence.csv

rm -f ref.db
sqlite3 ref.db <<EOT

CREATE TABLE redisNodeType(
  "index_id" TEXT,
  "region" TEXT,
  "node_type" TEXT,
  "vcpu" TEXT,
  "MemorySizeGiB" TEXT
);

CREATE TABLE memcachedNodeType(
  "index_id" TEXT,
  "region" TEXT,
  "node_type" TEXT,
  "vcpu" TEXT,
  "MemorySizeGiB" TEXT
);

CREATE TABLE nodePrice(
  "indexs" TEXT,
  "priceUSD" TEXT
);

CREATE TABLE regionCodes(
  "aws_region_code" TEXT,
  "aws_region_name" TEXT,
  "year_of_launch" TEXT
);

CREATE TABLE sequence(
  "seq_no" TEXT
);

--CREATE TABLE RedisNodes(
--  index_id TEXT,
--  aws_region_code TEXT,
--  aws_region TEXT,
--  node_type TEXT,
--  vcpu TEXT,
--  MemorySizeGiB TEXT,
--  priceUSD TEXT
--);
--
--CREATE TABLE MemcachedNodes(
--  index_id TEXT,
--  aws_region_code TEXT,
--  aws_region TEXT,
--  node_type TEXT,
--  vcpu TEXT,
--  MemorySizeGiB TEXT,
--  priceUSD TEXT
--);


.mode csv
.import redis_node_type.csv redisNodeType
.import memcached_node_type.csv memcachedNodeType
.import node_price.csv nodePrice
.import region_codes_data.csv regionCodes
.import sequence.csv sequence

update redisNodeType
set MemorySizeGiB=replace(MemorySizeGiB,' GiB','');

update memcachedNodeType
set MemorySizeGiB=replace(MemorySizeGiB,' GiB','');

.header on
.separator "\t"
.mode column
.nullvalue NULL


create table RedisNodes as
select distinct r.index_id,c.aws_region_code,r.region aws_region,r.node_type,r.vcpu,r.MemorySizeGiB,n.priceUSD
from redisNodeType r join regionCodes c on r.region=c.aws_region_name
join nodePrice n on substr(n.indexs,0,instr(n.indexs,'.'))=r.index_id;

create table MemcachedNodes as
select distinct r.index_id,c.aws_region_code,r.region aws_region,r.node_type,r.vcpu,r.MemorySizeGiB,n.priceUSD
from memcachedNodeType r join regionCodes c on r.region=c.aws_region_name
join nodePrice n on substr(n.indexs,0,instr(n.indexs,'.'))=r.index_id;

EOT

