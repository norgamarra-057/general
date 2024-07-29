#!/usr/bin/env python3

# ssh gds-prd-rds02.snc1
# python3

    # pip3 install boto3 --user
    # pip3 install pandas --user
    # pip3 install pandasql --user


import pandas as pd
import boto3
import pandasql as ps 


def db_cluster_endpoints(my_client):    
    response = my_client.describe_db_cluster_endpoints()
    my_list=response['DBClusterEndpoints']
    if('Marker' in response.keys()):
        my_marker=response['Marker']
    for x in range(10):
        if('Marker' in response.keys()):
            tmp_resp=my_client.describe_db_cluster_endpoints(Marker=my_marker)
            my_list= my_list + tmp_resp['DBClusterEndpoints']
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


def db_instances_paginator(my_client):    
    response = my_client.describe_db_instances()
    my_list=response['DBInstances']
    if('Marker' in response.keys()):
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
rds_instances_usw1_df=db_instances_paginator(client)
rds_instances_usw1_df['region_code']='usw1'
rds_endpoints_usw1_df=db_cluster_endpoints(client)
# rds_instances_usw1_df2=ps.sqldf("""
# select b.Endpoint as writer, replace(b.Endpoint,'cluster-','cluster-ro-') as reader
# ,a.*
# from rds_instances_usw1_df a
# left join rds_endpoints_usw1_df b
# on a.DBClusterIdentifier=b.DBClusterIdentifier
# where b.EndpointType='WRITER'
# """)


client2 = boto3.client('rds', region_name='us-west-2')
rds_instances_usw2_df=db_instances_paginator(client2)
rds_instances_usw2_df['region_code']='usw2'
rds_endpoints_usw2_df=db_cluster_endpoints(client2)
# rds_instances_usw2_df2=ps.sqldf("""
# select b.Endpoint as writer, replace(b.Endpoint,'cluster-','cluster-ro-') as reader
# ,a.*
# from rds_instances_usw2_df a
# left join rds_endpoints_usw2_df b
# on a.DBClusterIdentifier=b.DBClusterIdentifier
# where b.EndpointType='WRITER'
# """)

client = boto3.client('rds', region_name='eu-west-1')
rds_instances_euw1_df=db_instances_paginator(client)
rds_instances_euw1_df['region_code']='euw1'
rds_endpoints_euw1_df=db_cluster_endpoints(client)
# rds_instances_euw1_df2=ps.sqldf("""
# select b.Endpoint as writer, replace(b.Endpoint,'cluster-','cluster-ro-') as reader
# ,a.*
# from rds_instances_euw1_df a
# left join rds_endpoints_euw1_df b
# on a.DBClusterIdentifier=b.DBClusterIdentifier
# where b.EndpointType='WRITER'
# """)


# rds_all_0=pd.concat([rds_instances_usw1_df2,rds_instances_usw2_df2,rds_instances_euw1_df2],axis=0)

rds_all_0=pd.concat([rds_instances_usw1_df,rds_instances_usw2_df,rds_instances_euw1_df],axis=0)
rds_all=ps.sqldf(' select distinct * from rds_all_0 ');
rds_all.to_csv('rds_instances_all_prod.csv',index=False, sep='\t')


rds_endpoints_all_0=pd.concat([rds_endpoints_usw1_df,rds_endpoints_usw2_df,rds_endpoints_euw1_df],axis=0)
rds_endpoints_all=ps.sqldf(' select distinct * from rds_endpoints_all_0 ');
rds_endpoints_all.to_csv('rds_endpoints_all_prod.csv',index=False, sep='\t')
