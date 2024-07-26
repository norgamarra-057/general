from pprint import pprint
import redis as r 
import nmap
import socket
import os 
import subprocess
import sqlite3 
import time
import pandas as pd

def get_host_names(dbname,colo):
    # get_host_names('redis','dub1')
    os.chdir('/home/ksatyamurthy/ops-config/hosts')
    hosts_tmp=subprocess.check_output('ls  '.split()).decode('utf8').split('\n')
    hosts=[x[:-4] for x in hosts_tmp if dbname in x and colo in x ]
    return hosts

def get_clients_redis(hostname,port):
    conn1=r.Redis(hostname,port)
    data3=conn1.client_list()
    s_set=set()
    
    # remove duplicate ip's
    for i in range(len(data3)):
        s_set.add(data3[i]['addr'].split(':')[0])

    # resolve ip to hostname
    client_hostname=[]
    for x in s_set:
        ip1=socket.gethostbyaddr(x)[0]
        if(not ip1.startswith('raas')):
            client_hostname.append(socket.gethostbyaddr(x)[0])
    return sorted(client_hostname)

def scan_for_redis(hostname,sqlite_db):
    nm = nmap.PortScanner()
    pscan=nm.scan(hostname, '-')
    conn=sqlite3.connect(sqlite_db)
    #cur=conn.cursor()
    openports=list(filter(lambda score: score >= 4001,list(pscan['scan'][list(pscan['scan'].keys())[0]]['tcp'].keys())))
    #print(str(openports))
    for p in openports:
        try:
            conn1=r.Redis(hostname,p)
            info_data=conn1.info()
            #print(hostname,p)
            sql1=f"""
            insert into redis_servers values('{hostname}',{p});
            """
            #print(sql1)
            conn.execute(sql1)
            #print(hostname,p,conn1.info()['redis_version'])
        except:
            pass
        finally:
            conn1.close()
    conn.commit()
    conn.close()

def dbinfo(host,port,sqlite_db):
    print(host,port)
    try:
        conn1=r.Redis(host,port)
        info_data=conn1.info()
    except:
        return None
    conn=sqlite3.connect(sqlite_db) 

    # No of keys
    no_of_db=0
    tot_keys=0
    for dbs in [ x for x in list(info_data.keys()) if x.startswith('db') ]:
        tot_keys=tot_keys + int(info_data[dbs]['keys'])
        no_of_db=no_of_db + 1
    
    # version 
    version=info_data['redis_version']
    # role
    try:
        role=info_data['role']
    except:
        role='sentinel'
    mode=info_data['redis_mode']
    
    # master host 
    try:
        master_host=socket.gethostbyaddr(info_data['master_host'])[0]+':'+str(info_data['master_port'])
    except:
        try:
            master_host=socket.gethostbyaddr(info_data['slave0']['ip'])[0]+':'+str(info_data['slave0']['port'])
        except:
            master_host=''

    # uptime
    uptime_days=str(info_data['uptime_in_days'])
    
    # no of clients 
    try:
        no_of_clients=str(info_data['connected_clients'])
    except:
        no_of_clients='0'
    
    # Traffic status 
    traff_status=check_traffic_redis(host,port,100)

    # memory usage
    try:
        used_memory=str(info_data['used_memory'])
    except:
        used_memory='0'

    try:
        used_memory_human=info_data['used_memory_human']
    except:
        used_memory_human='0'
        
    try:
        used_memory_peak_human=info_data['used_memory_peak_human']
    except:
        used_memory_peak_human='0'
        
    try:
        client_list=get_clients_redis(host,port)
    except:
        client_list=''
    
    sql2=f""" 
    insert into redis_dbinfo
    values (
    '{host}',
    {port},
    {no_of_db},
    {tot_keys},
    '{version}',
    '{role}',
    '{mode}',
    '{master_host}',
    {uptime_days},
    {no_of_clients},
    {used_memory},
    '{used_memory_human}',
    '{used_memory_peak_human}',
    '{traff_status}',
    "{client_list}"
    )
    """
    #print(sql2)
    conn.execute(sql2);
    
    conn.commit()
    conn.close()

def check_traffic_redis(host,port,wait_seconds):
    conn1=r.Redis(host,port)
    data1=conn1.info(section='commandstats')
    time.sleep(wait_seconds)
    data2=conn1.info(section='commandstats')
    df_data1=pd.DataFrame(data1)
    df_data2=pd.DataFrame(data2)
    conn1.close()
    df_data1.drop(['cmdstat_ping','cmdstat_client','cmdstat_info','cmdstat_replconf'],axis=1,inplace=True,errors='ignore')
    df_data2.drop(['cmdstat_ping','cmdstat_client','cmdstat_info','cmdstat_replconf'],axis=1,inplace=True,errors='ignore')
    df_data1.drop(['usec','usec_per_call'],axis=0,inplace=True,errors='ignore')
    df_data2.drop(['usec','usec_per_call'],axis=0,inplace=True,errors='ignore')
    if(df_data1.equals(df_data2)):
        return 'No traffic'
    else:
        return 'Traffic seen'


def main():
    host_names=get_host_names('im-redis','dub1')
    os.chdir('/home/ksatyamurthy')
    sqlite_db='/home/ksatyamurthy/legacy-redis-IM-09-03-2021.db'
    conn=sqlite3.connect(sqlite_db)
    cur=conn.cursor()
    cur.execute('drop table if exists redis_dbinfo;')
    cur.execute("""
    create table redis_dbinfo (hostname varchar(125), 
    port int,
    no_of_db int,
    tot_keys int,
    version varchar(20),
    role varchar(20),
    mode varchar(20),
    master_or_slave_host varchar(120),
    uptime_days int,
    connected_clients int, 
    used_memory_bytes int,
    used_memory_human varchar(125),
    used_memory_peak_human varchar(125),
    traffic_status varchar(25),
    client_list varchar(1024)
    );
    """)
    
    cur.execute('drop table if exists redis_servers ;')
    cur.execute('create table redis_servers (hostname varchar(125), port int);')

    #host_names=['im-redis-node1.dub1']
    print(str(host_names))
    for x in host_names:
        print("scan: "+x)
        scan_for_redis(x,sqlite_db)
    
    
    cur.execute("""
    select hostname,port from redis_servers
    """) 
    
    for h, p in cur.fetchall():
        print(h,p,sqlite_db)
        dbinfo(h,p,sqlite_db)

    
    cur.close()
    conn.close()

main()
