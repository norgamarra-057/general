#!/usr/bin/env python3


# Fetch RDS node price information from aws api

import pandas as pd 
pd.set_option('display.max_colwidth', 500)
pd.set_option("display.max_columns", 500)
pd.options.display.max_rows = 5000

import requests 
import json 
import urllib.request

import sqlite3
conn = sqlite3.connect(":memory:")

import pandasql as ps  



# url data 
def read_url_data(url):
    with urllib.request.urlopen(url) as response:
        html_data = response.read().decode('utf-8')
    return json.loads(html_data)
    
# denorm for products
def denorm_products(data): 
    data1=[ data['products'][x] for x in data['products'] ]
    df1=pd.json_normalize(data1)
    return df1 

# denorm for terms
def denorm_terms(data):
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
    df2=pd.json_normalize(data4)
    return df2 


url1="https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonRDS/current/us-west-1/index.json"
url2="https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonRDS/current/us-west-2/index.json"
url3="https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonRDS/current/eu-west-1/index.json"


data1=read_url_data(url1)
data2=read_url_data(url2)
data3=read_url_data(url3)

# products table all regions
df1_a=denorm_products(data1)
df1_b=denorm_products(data2)
df1_c=denorm_products(data3)
df1_all=[df1_a,df1_b,df1_c]
df1=pd.concat(df1_all)
df1.to_sql("rds_nodetype_product", conn, if_exists="replace")
conn.commit() 

#pd.read_sql_query(" SELECT * FROM rds_nodetype_product WHERE  `attributes.regionCode` in ('us-west-1','us-west-2','eu-west-1') and `attributes.currentGeneration`='Yes'  ", conn)

# terms table all regions
# Denormalize the nested json to tabular form and load to sqlite3 table rds_nodetype_term
df2_a=denorm_terms(data1)
df2_b=denorm_terms(data2)
df2_c=denorm_terms(data3)

df2_all=[df2_a,df2_b,df2_c]
df2=pd.concat(df2_all)
df2.to_sql("rds_nodetype_term", conn, if_exists="replace")
conn.commit() 

df3=pd.read_sql_query("""
SELECT --a.*,
--a.productFamily,
--a.`attributes.servicecode`,
--a.`attributes.location`,
--a.`attributes.locationType`,
--a.`attributes.storageMedia`,
--a.`attributes.volumeType`,
--a.`attributes.minVolumeSize`,
--a.`attributes.maxVolumeSize`,
--a.`attributes.engineCode`,
a.`attributes.databaseEngine`,
a.`attributes.deploymentOption`,
a.`attributes.usagetype`,
--a.`attributes.operation`,
a.`attributes.regionCode`,
--a.`attributes.servicename`,
a.`attributes.instanceType`,
--a.`attributes.currentGeneration`,
a.`attributes.instanceFamily`,
a.`attributes.vcpu`,
a.`attributes.clockSpeed`,
a.`attributes.physicalProcessor`,
a.`attributes.memory`,
a.`attributes.storage`,
a.`attributes.networkPerformance`,
a.`attributes.processorArchitecture`,
a.`attributes.databaseEdition`,
a.`attributes.licenseModel`,
a.`attributes.instanceTypeFamily`,
a.`attributes.normalizationSizeFactor`,
a.`attributes.dedicatedEbsThroughput`,
a.`attributes.enhancedNetworkingSupported`,
a.`attributes.processorFeatures`,
--a.`attributes.group`,
--a.`attributes.groupDescription`,
--a.`attributes.acu`,
--b.effectiveDate as effectiveDate,
--b.rateCode,
--b.description,
--b.beginRange,
--b.endRange,
--b.unit,
b.pricePerUnit as pricePerUnit
FROM rds_nodetype_product a LEFT JOIN rds_nodetype_term b
ON a.sku=b.sku
WHERE `attributes.databaseEngine` in ('PostgreSQL','MySQL','Aurora PostgreSQL','Aurora MySQL')  and 
--productFamily in ('Database Instance') and 
a.`attributes.locationType`='AWS Region' and
`attributes.regionCode` in ('us-west-1','us-west-2','eu-west-1') and `attributes.currentGeneration`='Yes'
""", conn)


df3.to_csv('rds_node_terms.csv',index=False)