#!/usr/bin/env python3

import json
import pandas as pd 
import pandasql as ps 
import boto3

# AWS cli commands to generate these 3 files 
#
# prod.us-west-1  Z149J4JE6N1OEF
#   aws-okta exec prd -- aws route53   list-resource-record-sets --hosted-zone-id Z149J4JE6N1OEF --query "ResourceRecordSets[?Type == 'CNAME']" > r53_prod_usw1.json
#
# prod.us-west-2  Z44QSCLVUU9XB
#   aws-okta exec prd -- aws route53   list-resource-record-sets --hosted-zone-id Z44QSCLVUU9XB --query "ResourceRecordSets[?Type == 'CNAME']"  > r53_prod_usw2.json
#
# prod.eu-west-1  Z1H3C0GFLBTSE2
#   aws-okta exec prd -- aws route53   list-resource-record-sets --hosted-zone-id Z1H3C0GFLBTSE2 --query "ResourceRecordSets[?Type == 'CNAME']" > r53_prod_euw1.json
# 


# with open('r53_prod_usw1.json') as json_file:
# 	r53_usw1 = json.load(json_file)

# with open('r53_prod_usw2.json') as json_file:
# 	r53_usw2 = json.load(json_file)

# with open('r53_prod_euw1.json') as json_file:
# 	r53_euw1 = json.load(json_file)


# r53=[]
# for x in range(len(r53_usw1)):
# 	r53.append([r53_usw1[x]['Name'][:-1],r53_usw1[x]['ResourceRecords'][0]['Value']])
# 	#print(data[x]['Name'][:-1],data[x]['ResourceRecords'][0]['Value'])

# for x in range(len(r53_usw2)):
# 	r53.append([r53_usw2[x]['Name'][:-1],r53_usw2[x]['ResourceRecords'][0]['Value']])

# for x in range(len(r53_euw1)):
# 	r53.append([r53_euw1[x]['Name'][:-1],r53_euw1[x]['ResourceRecords'][0]['Value']])



client = boto3.client('route53')

paginator = client.get_paginator('list_resource_record_sets')


r53=[]
source_zone_records = paginator.paginate(HostedZoneId='Z149J4JE6N1OEF')
for record_set in source_zone_records:
  for record in record_set['ResourceRecordSets']:
    if record['Type'] == 'CNAME' and record['Name'].startswith('gds'):
      r53.append([record['Name'][:-1],record['ResourceRecords'][0]['Value']])
      #print(record['Name'][:-1],record['ResourceRecords'][0]['Value'])


source_zone_records = paginator.paginate(HostedZoneId='Z44QSCLVUU9XB')
for record_set in source_zone_records:
  for record in record_set['ResourceRecordSets']:
    if record['Type'] == 'CNAME' and record['Name'].startswith('gds'):
      r53.append([record['Name'][:-1],record['ResourceRecords'][0]['Value']])
      #print(record['Name'][:-1],record['ResourceRecords'][0]['Value'])


source_zone_records = paginator.paginate(HostedZoneId='Z1H3C0GFLBTSE2')
for record_set in source_zone_records:
  for record in record_set['ResourceRecordSets']:
    if record['Type'] == 'CNAME' and record['Name'].startswith('gds'):
      r53.append([record['Name'][:-1],record['ResourceRecords'][0]['Value']])
      #print(record['Name'][:-1],record['ResourceRecords'][0]['Value'])

r53_df=pd.DataFrame(r53,columns=['r53_Name','r53_ResourceRecordsValue'])

r53_df2=ps.sqldf("""
select r53_Name,r53_ResourceRecordsValue from r53_df where r53_Name like 'gds%'
""")


r53_df2.to_csv('route53_cname.csv',index=False)

