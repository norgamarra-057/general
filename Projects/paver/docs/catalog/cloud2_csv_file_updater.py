#!/usr/bin/python3

import pandas as pd
import boto3
import pandasql as ps 


def db_instances_paginator(my_client):    
    response = client.describe_db_instances()
    my_list=response['DBInstances']
    my_marker=response['Marker']
    for x in range(10):
        if('Marker' in response.keys()):
            tmp_resp=my_client.describe_db_instances(Marker=my_marker)
            my_list= my_list + tmp_resp['DBInstances']
            if('Marker' not in tmp_resp.keys()):
                break
            else:
                # print("Marker updated.")
                my_marker=tmp_resp['Marker']
                continue
        else:
            break
    df=pd.json_normalize(my_list, max_level=2,errors='ignore',sep='.') 
    df=df.astype(str)
    return df 


client = boto3.client('rds', region_name='us-west-1')
rds_instances_df=db_instances_paginator(client)

rds_instances_df.to_csv('rds_instances_usw1_prod.csv',index=False)
