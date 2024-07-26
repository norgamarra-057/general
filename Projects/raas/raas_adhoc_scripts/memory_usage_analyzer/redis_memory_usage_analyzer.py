
import redis as r 
import time
import pandas as pd
import mysql.connector
import requests
import pprint
import concurrent.futures
import tqdm
import seaborn as sns 
import sys 
import pandasql as ps
import pickle
import pandas_profiling

host='getaways-search-cache--redis.staging.stable.us-west-1.aws.groupondev.com'
conn1=r.Redis(host,6379,0)

def run_in_pipe(redis_conn,batch_size,key_list,cmd):
    pipe=redis_conn.pipeline()
    full_result=[]
    while(len(key_list)>0):
        list1=key_list[:batch_size]
        for key in list1:
            exec("pipe."+cmd+"'"+key+"')")
        result=pipe.execute()
        full_result=full_result+result
        key_list=key_list[batch_size:]
    pipe.close()
    return full_result

def list_bytes_to_str(list1):
    list_tmp=[]
    for x in list1:
        if(type(x).__name__=='bytes'):
            list_tmp.append(x.decode('utf8'))
        else:
            list_tmp.append(x)
    return list_tmp

def run_in_pipe2(redis_conn,batch_size,key_list,key_list2):
    pipe=redis_conn.pipeline()
    full_result=[]
    while(len(key_list)>0):
        list1=key_list[:batch_size]
        list2=key_list2[:batch_size]
        for index,key in enumerate(list1):
            typ=list2[index]
            if(typ=='set'):
                pipe.scard(key);
            elif(typ=='sortedset'):
                pipe.zrange(key,0,-1);
            elif(typ=='list'):
                pipe.lrange(key,0,-1);
            elif(typ=='hash'):
                pipe.hlen(key);
            elif(typ=='string'):
                pipe.strlen(key);
            else:
                pipe.echo('-1');
        result=pipe.execute()
        full_result=full_result+result
        key_list=key_list[batch_size:]
        key_list2=key_list2[batch_size:]
    pipe.close()
    return full_result

keyname=[ key.decode('utf8') for key in tqdm.tqdm(conn1.scan_iter(count=500_000)) ]

output_ttl=run_in_pipe(conn1,200_000,keyname,'ttl(')

output_type1=run_in_pipe(conn1,200_000,keyname,'type(')
output_type=[ x.decode('utf8') for x in output_type1 ]
del output_type1

output_mem=run_in_pipe(conn1,200_000,keyname,'memory_usage(')

output_idletime=run_in_pipe(conn1,200_000,keyname,"object('idletime',")

def run_in_pipe2(redis_conn,batch_size,key_list,key_list2):
    pipe=redis_conn.pipeline()
    full_result=[]
    while(len(key_list)>0):
        list1=key_list[:batch_size]
        list2=key_list2[:batch_size]
        for index,key in enumerate(list1):
            typ=list2[index]
            if(typ=='set'):
                pipe.scard(key);
            elif(typ=='sortedset'):
                pipe.zrange(key,0,-1);
            elif(typ=='list'):
                pipe.lrange(key,0,-1);
            elif(typ=='hash'):
                pipe.hlen(key);
            elif(typ=='string'):
                pipe.strlen(key);
            else:
                pipe.echo('-1');
        result=pipe.execute()
        full_result=full_result+result
        key_list=key_list[batch_size:]
        key_list2=key_list2[batch_size:]
    pipe.close()
    return full_result

output_len1=run_in_pipe2(conn1,200_000,keyname,output_type)
output_len=list_bytes_to_str(output_len1)
del output_len1

print(len(keyname),len(output_ttl),len(output_type),len(output_mem),len(output_idletime),len(output_len))

df1=pd.DataFrame(data=list(zip(keyname,output_ttl,output_type,output_mem,output_idletime,output_len)),columns=['keys','ttl','type','memory','idletime','length'])
del keyname,output_ttl,output_type,output_mem,output_idletime,output_len

df2=ps.sqldf("select keys, ttl, type, memory as mem_bytes, idletime/(24*3600) idle_days from df1")

#report=pandas_profiling.ProfileReport(df1)
#report.to_file(output_file='output.html')

df2.to_csv('key_attributes.csv') 



