import pandas as pd 
import redis as r 
import hcl2
import requests

import pandasql as ps

def get_redis_db_list(region='us-west-1'):

    if(region=='us-west-1'):
        dir_path_var='usw1'
    elif(region=='eu-west-1'):
        dir_path_var='euw1'

    url=f"https://raw.github.groupondev.com/data/raas/master/raas_aws/terragrunt_live/prd_{dir_path_var}/redis/instances.auto.tfvars"
    
    response=requests.get(url)
    dict_tf = hcl2.loads(response.text)

    bast_hosts=['billing-record-service','content-service-cache','custsvc-cache','custsvc-tokenizer','flying-dutchman','fraud','fraud-arbiter-queue','fraud-arbiter-cache','gdt-automation','orders-dashboard','salesforce-proxy','test-bast','ticketsvc','transporter','unity-gifting-emailer','users-service']

    bast_hosts1=[ 'redis-'+x for x in bast_hosts ]

    hostname=[]


    for x in dict_tf:
        if x not in bast_hosts1:
            hostname.append((x.replace('redis-','')+f"--redis.prod.prod.{region}.aws.groupondev.com",dict_tf[x][0]['node_type']))
            #print(x.replace('redis-','')+f"--redis.prod.prod.{region}.aws.groupondev.com",dict_tf[x]['node_type'])

    return hostname

db_list=get_redis_db_list('eu-west-1') 

err=[]
db_properties=[]

for x in range(len(db_list)):
    
    db=db_list[x][0]
    node_type=db_list[x][1]
    conn=r.Redis(host=db,port=6379,decode_responses=True,socket_timeout=10)
    try:
        info_data=conn.info()
    except:
        err.append(db)
        continue
    if(info_data['cluster_enabled']==0):            # STANDALONE
        db_info={ "name": db, "port": 6379, "node_type": node_type , "db_type": 'standalone', "node_ip": '127.0.0.1', "redis_version": info_data['redis_version'], "uptime_in_days": info_data['uptime_in_days'], "used_memory": info_data['used_memory'], "used_memory_peak": info_data['used_memory_peak'] , "maxmemory": info_data['maxmemory']  }
        db_properties.append(db_info)
    else:                                           # CLUSTER
        primary_nodes=[]
        nodes_dict=conn.cluster('nodes')
        for ids in list(nodes_dict):
            if "master" in nodes_dict[ids]["flags"]:
                primary_nodes.append(ids.split("@")[0].split(":"))
        
        for h in primary_nodes:
            conn_tmp=r.Redis(host=h[0],port=6379,decode_responses=True,socket_timeout=10)
            info_data=conn_tmp.info()
            db_info={ "name": db, "port": 6379, "node_type": node_type, "db_type": 'cluster', "node_ip": h[0], "redis_version": info_data['redis_version'], "uptime_in_days": info_data['uptime_in_days'], "used_memory": info_data['used_memory'], "used_memory_peak": info_data['used_memory_peak'] , "maxmemory": info_data['maxmemory']  }
            db_properties.append(db_info)
            conn_tmp.close()
    
    conn.close()

df = pd.DataFrame(db_properties)

df.to_csv('redis_db_list_euw1.csv',index=False)

df1=ps.sqldf("""
select name, count(*) no_of_nodes,max(port) port, max(node_type) node_type, max(db_type) db_type, max(redis_version) redis_version, max(uptime_in_days) uptime_in_days, sum(used_memory) used_memory, sum(used_memory_peak) used_memory_peak, sum(maxmemory) maxmemory from df group by 1;
""")

eu_price=pd.read_csv('euw1_price.csv')

df_output=ps.sqldf("""
select b."Price_With_rep($/Month)",a.* from df1 a join eu_price b on trim(cast(a.no_of_nodes as varchar(5))||' x '||a.node_type)=trim(b.InstanceConfig)
""")


df_output.to_csv('euw1_underutilized.csv',index=False)
