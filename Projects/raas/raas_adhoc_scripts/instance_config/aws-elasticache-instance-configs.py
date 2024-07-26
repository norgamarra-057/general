#!/usr/bin/env python3

import sqlite3
import json 
import pandas as pd 
 

pd.set_option('display.max_colwidth', None)
pd.set_option("display.max_columns", 500)
pd.options.display.max_rows = 5000


##     Jupyter lite code (Javascript code)
#from pyodide.http import pyfetch
#import asyncio
# response = await pyfetch(url="https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonElastiCache/current/index.json")
# content=(await response.json())
# content1=json.dumps(content)
# data=json.loads(content1)

##     Python code 
import requests
url='https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonElastiCache/current/index.json'
r=requests.get(url)
data = r.json()


conn = sqlite3.connect(":memory:")

data1=[]
for x in data['products']:
    data1.append(data['products'][x])

data1=[ data['products'][x] for x in data['products'] ]

data2=[ data['terms'][x] for x in data['terms'] ]
data3=[ data2[0][x] for x in data2[0] ]
data4=[]
for x in range(len(data3)):
    for key in data3[x]:
        offerTermCode=data3[x][key]['offerTermCode']
        sku=data3[x][key]['sku']
        effectiveDate=data3[x][key]['effectiveDate']
        
        for key1 in data3[x][key]['priceDimensions']:
            rateCode=data3[x][key]['priceDimensions'][key1]['rateCode']
            description=data3[x][key]['priceDimensions'][key1]['description']
            beginRange=data3[x][key]['priceDimensions'][key1]['beginRange']
            endRange=data3[x][key]['priceDimensions'][key1]['endRange']
            unit=data3[x][key]['priceDimensions'][key1]['unit']
            pricePerUnit=data3[x][key]['priceDimensions'][key1]['pricePerUnit']['USD']

        tmp_data={ 'offerTermCode': offerTermCode, 'sku': sku, 'effectiveDate': effectiveDate, 'rateCode': rateCode, 'description': description, 'beginRange': beginRange, 'endRange': endRange, 'unit': unit, 'pricePerUnit': pricePerUnit }
        data4.append(tmp_data)


df1=pd.json_normalize(data1)
df2=pd.json_normalize(data4)

df1.to_sql("ec_nodetype_prod", conn, if_exists="replace")
df2.to_sql("ec_nodetype_term", conn, if_exists="replace")


df3=pd.read_sql_query("""
SELECT --a.sku,
--a.productFamily,
--a.`attributes.servicecode`,
a.`attributes.location` as location,
--a.`attributes.locationType` as locationType,
a.`attributes.instanceType` as instanceType,
--a.`attributes.currentGeneration` as currentGeneration,
a.`attributes.instanceFamily` as instanceFamily,
a.`attributes.vcpu` as vcpu,
replace(a.`attributes.memory`,' GiB','') as memory,
a.`attributes.networkPerformance` as networkPerformance,
a.`attributes.cacheEngine` as cacheEngine,
--a.`attributes.usagetype` as usageType,
--a.`attributes.operation` as operation,
a.`attributes.regionCode` as regionCode,
--a.`attributes.servicename` as servicename,
replace(a.`attributes.ssd`,' GiB','') as ssd,
--a.`attributes.transferType` as transferType,
--a.`attributes.storageMedia` as storageMedia,
--a.`attributes.group` as group,
--a.`attributes.groupDescription` as groupDescription,
--b.offerTermCode as offerTermCode,
b.effectiveDate as effectiveDate,
--b.rateCode,
--b.description,
--b.beginRange,
--b.endRange,
--b.unit,
b.pricePerUnit as pricePerUnit
FROM ec_nodetype_prod a JOIN ec_nodetype_term b
ON a.sku=b.sku
WHERE --`attributes.cacheEngine`='Redis' and 
`attributes.regionCode` in ('us-west-1','us-west-2','eu-west-1') and `attributes.currentGeneration`='Yes'
and `attributes.instanceType` not like 'cache.r5%'
and `attributes.instanceType` not like 'cache.r4%'
and `attributes.instanceType` not like 'cache.m4%'
and `attributes.instanceType` not like 'cache.m5%'
and `attributes.instanceType` not like 'cache.t2%'
and `attributes.instanceType` not like 'cache.t3%'
""", conn)


df3.to_sql("ec_nodetype", conn, if_exists="replace")

cur = conn.cursor()
cur.execute("drop table if exists seq;")
cur.execute("create table seq ( seq_no int );")
for x in range(150):
    cur.execute(f"insert into seq (seq_no) values ({x+1});")
conn.commit()

req_mem=200
region_code='us-west-1' # us-west-1, us-west-2, eu-west-1
cache_engine='Redis'    # Redis, Memcached
db_type='cluster'    # standalone, cluster
data_tier=False

# req_mem = Element('req-mem').element.value
# region_code = Element('region-code').element.value
# cache_engine = Element('engine').element.value
# db_type = Element('db-type').element.value
# data_tier = Element('data-tier').element.value

# if(data_tier=='False'):
#     data_tier=False
# else:
#     data_tier=True

if(db_type=='standalone'):
    filter1='AND b.seq_no=1 '    
elif(db_type=='cluster'):
    filter1='AND b.seq_no>1 '    

if(cache_engine=='Redis'):
    if(not data_tier):
        mem_formula1='(b.seq_no*a.memory*0.75)'
        mem_formula2='(b.seq_no*a.memory*0.75)'
        filter2='AND TotalMemoryWithSSD is null '
    else:
        mem_formula1='(b.seq_no*a.memory*0.75)'
        mem_formula2='((b.seq_no*a.memory*0.75)+ssd)'        
        filter2='AND TotalMemoryWithSSD is not null '
elif(cache_engine=='Memcached'):
    if(not data_tier):
        mem_formula1='(((b.seq_no*a.memory)-(b.seq_no*0.1)))'
        mem_formula2='(((b.seq_no*a.memory)-(b.seq_no*0.1)))'
        filter2='AND TotalMemoryWithSSD is null'
    else:
        mem_formula1='(((b.seq_no*a.memory)-(b.seq_no*0.1)))'
        mem_formula2='((((b.seq_no*a.memory)-(b.seq_no*0.1)))+ssd)'
        filter2='AND TotalMemoryWithSSD is not null '

# output_df=pd.read_sql_query(f"""
# SELECT
# --a.instanceType,
# a.instanceFamily,
# a.vcpu,
# a.memory,
# a.networkPerformance,
# a.ssd,
# a.pricePerUnit
# ,(cast(b.seq_no as varchar(5))||' x '||a.instanceType) InstanceConfig 
# ,{mem_formula1} AllocatedMemory, 
# {mem_formula1}+(b.seq_no*ssd) TotalMemoryWithSSD 
# ,b.seq_no*a.pricePerUnit*24*30 as "Price_No_rep($/Month)"
# ,2*b.seq_no*a.pricePerUnit*24*30 as "Price_With_rep($/Month)"
# FROM ec_nodetype a, seq b 
# WHERE cacheEngine='{cache_engine}'
# AND regionCode='{region_code}'
# AND ({mem_formula2}) between {req_mem}*0.80 and {req_mem}*5.0
# {filter1}
# {filter2}
# order by "Price_With_rep($/Month)"
# """, conn)

output_df=pd.read_sql_query(f"""
SELECT
a.regionCode,
--a.instanceType,
a.instanceFamily,
a.vcpu,
a.memory,
a.networkPerformance,
a.ssd,
a.pricePerUnit
,(cast(b.seq_no as varchar(5))||' x '||a.instanceType) InstanceConfig 
,{mem_formula1} AllocatedMemory, 
{mem_formula1}+(b.seq_no*ssd) TotalMemoryWithSSD 
,b.seq_no*a.pricePerUnit*24*30 as "Price_No_rep($/Month)"
,2*b.seq_no*a.pricePerUnit*24*30 as "Price_With_rep($/Month)"
FROM ec_nodetype a, seq b 
WHERE a.cacheEngine='{cache_engine}'
--AND a.regionCode='{region_code}'
--AND ({mem_formula2}) between {req_mem}*0.80 and {req_mem}*5.0
--{filter1}
--{filter2}
order by "Price_With_rep($/Month)"
""", conn)


output_df.to_csv('/Users/ksatyamurthy/Desktop/aws-ec-node-instance-config.csv',header=True,index=False)