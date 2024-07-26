#!/usr/bin/env python
# coding: utf-8

# USAGE: 
    # conda activate
    # python3 <SCRIPT> dbname hostname port 

import sys
import redis as r
import pandas as pd
import pandasql as ps
from datetime import datetime
# redis-10101.snc1.raas-shared3-staging.grpn
# port: 10101

# dbname="janus01"
# hostname="redis-10001.us.raas-janus-prod.grpn"
# port=10001
#hostname="redis-10101.snc1.raas-shared3-staging.grpn"
#hostname="redis-10103.snc1.raas-shared3-staging.grpn"
#port=10103
dbname=sys.argv[1]
hostname=sys.argv[2]
port=sys.argv[3]
db=0
scan_buffer_size=100_000

def t(input):
    print(input + " " + datetime.now().strftime("%Y-%m-%d %H:%M:%S"))

def scan_keys(hostname,portno,db,scancount):
    keys_names=[]
    keys_ttls=[]
    keys_idletime=[]
    rc=r.Redis(host=hostname,port=portno,db=db)
    print("Connected to redis")
    total_no_of_keys=rc.info()['db0']['keys']
    tmp=rc.scan(0,count=scancount)
    tmp_processed_keys=0
    t("start of loop")
    while tmp[0] != 0:
        tmp_processed_keys=tmp_processed_keys+len(tmp[1])
        t("  start")
        print(f"  Scanned: {tmp_processed_keys} which is {100*tmp_processed_keys/total_no_of_keys:.2f} % of keys ({total_no_of_keys})")
        for key in range(len(tmp[1])):
            keyname=tmp[1][key].decode("utf-8")
            keys_names.append(keyname)
            keys_ttls.append(rc.ttl(keyname))
            keys_idletime.append(rc.object("idletime",keyname))
        tmp=rc.scan(tmp[0],count=scancount)
    print("Scan loop completed")
    t("end  of loop")
    data_tuples=list(zip(keys_names,keys_ttls,keys_idletime))
    keys_info=pd.DataFrame(data_tuples, columns=['name','ttl','idletime'])
    return keys_info

def scankeys_and_apply_expire(hostname,portno,db,keylist,timeseconds):
    if(len(keylist)==0):
        return None
    keys_errorcode=[]
    ttl_before=[]
    memory_usage_bytes=[]
    rc=r.Redis(host=hostname,port=portno,db=db)
    for key in keylist:
        ttlvalue=rc.ttl(key)
        ttl_before.append(ttlvalue)
        memory_usage_bytes.append(rc.memory_usage(key))
        if(ttlvalue >= timeseconds):
            errcode=rc.expire(key,timeseconds)   # 1               #    IMPORTANT
            keys_errorcode.append(errcode)
        elif(ttlvalue == -1):
            errcode=rc.expire(key,timeseconds)   # 0               #    IMPORTANT
            keys_errorcode.append(errcode)
        elif(ttlvalue == -2):
            keys_errorcode.append(-2)
        elif(ttlvalue < timeseconds):
            keys_errorcode.append(-3)
        else:
            keys_errorcode.append(-4)
    data_tuples=list(zip(keylist,ttl_before,memory_usage_bytes,keys_errorcode))
    keys_info=pd.DataFrame(data_tuples, columns=['name','ttl_before','memory_usage_bytes','expire_status'])
    return keys_info
        
def scankeys_and_apply_delete(hostname,portno,db,keylist):
    if(len(keylist)==0):
        return None
    keys_errorcode=[]
    ttl_before=[]
    memory_usage_bytes=[]
    rc=r.Redis(host=hostname,port=portno,db=db)
    for key in keylist:
        ttlvalue=rc.ttl(key)
        errcode=rc.unlink(key)          # None                             #    IMPORTANT
        ttl_before.append(ttlvalue)
        keys_errorcode.append(errcode)
        memory_usage_bytes.append(rc.memory_usage(key))
    data_tuples=list(zip(keylist,ttl_before,memory_usage_bytes,keys_errorcode))
    keys_info=pd.DataFrame(data_tuples, columns=['name','ttl_before','memory_usage_bytes','delete_status'])
    return keys_info

# 2021-03-30 10:38:43
# 2021-03-30 12:15:17
# 97 mins to process 21,074,295 million keys
t("start")
keynames=scan_keys(hostname,port,db,scan_buffer_size)
t("end  ")
#keynames.to_csv(f'/home/ksatyamurthy/{dbname}_keynames.csv',index=False, header=True)

rconn=r.Redis(host=hostname,port=port,db=db)
# delete sales for which views are > 30 days
sales_unlink=ps.sqldf("select replace(name,'views','sales') name from keynames where idletime > 30*24*60*60*1.0 and name like '%views'")
df_join=pd.merge(sales_unlink,keynames,how="inner")
print(f"Delete sales...")
t("start")
delete_status=scankeys_and_apply_delete(hostname,port,db,list(df_join['name']))
t("end  ")

views_gt30days=ps.sqldf("select * from keynames where idletime > 30*24*60*60*1.0 and name like '%views'")
# set expire to 21 days when the views are not access > 1 month
print(f"Applying  21 days expire...")
t("start")  # 52 mins ((7466595, 3))
view_expire_status=scankeys_and_apply_expire(hostname,port,db,list(views_gt30days['name']),21*24*60*60)
t("end  ")
view_expire_status['expire_status'].value_counts()
#  0    4835136/21074776 no ttl 35% (21 days)
#  1    2508498
# -3     122381
# -2        580
#view_expire_status.to_csv(f'/home/ksatyamurthy/{dbname}_view_expire_status.csv',index=False, header=True)

sales_remaining=ps.sqldf("select * from keynames where name like '%sales'")
print(f"Applying 365 days expire...")
t("start")
sales_remaining_expire_status=scankeys_and_apply_expire(hostname,port,db,list(sales_remaining['name']),365*24*60*60)
t("end  ")
sales_remaining_expire_status['expire_status'].value_counts()
#sales_remaining_expire_status.to_csv(f'/home/ksatyamurthy/{dbname}_sales_remaining_expire_status.csv',index=False, header=True)

# 0    6676772   no ttl 32%


#ps.sqldf('select expire_status,count(*) from sales_remaining_expire_status group by 1')

views_new_ttl        =ps.sqldf(' select count(*) cnt from view_expire_status            where expire_status like "1%"')['cnt'][0]
views_ttl_untouched  =ps.sqldf(' select count(*) cnt from view_expire_status            where expire_status like "%-3%"')['cnt'][0]
sales_new_ttl        =ps.sqldf(' select count(*) cnt from sales_remaining_expire_status where expire_status like "1%"')['cnt'][0]
sales_ttl_untouched  =ps.sqldf(' select count(*) cnt from sales_remaining_expire_status where expire_status like "%-3%"')['cnt'][0]
totalno_keys         =keynames.shape[0]
views_new_memory_saved=ps.sqldf(' select sum(memory_usage_bytes)/(1024*1024) size_mb from view_expire_status  where expire_status like "1%"')['size_mb'][0]
sales_new_memory_saved=ps.sqldf(' select sum(memory_usage_bytes)/(1024*1024) size_mb from sales_remaining_expire_status  where expire_status like "1%"')['size_mb'][0]
db_size=rconn.info()['used_memory']/(1024*1024)
db_size_human=rconn.info ()['used_memory_human']


print(f'DB name : {hostname}')
print(f'Endpoint : {hostname}')
print(f'Total no of keys: {totalno_keys}')
print(f'Sales deleted   : {df_join.shape[0]}')
print(f'Views new ttl of 21 days  : {views_new_ttl}   Percent:{100.0*views_new_ttl/totalno_keys:.2f}')
print(f'Views untouched has <  21 days ttl  : {views_ttl_untouched}  Percent:{100.0*views_ttl_untouched/totalno_keys:.2f}')
print(f'Sales new ttl 365 days  : {sales_new_ttl}  Percent:{100.0*sales_new_ttl/totalno_keys:.2f}')
print(f'Sales untouched has < 365 days ttl  : {sales_ttl_untouched}  Percent:{100.0*sales_ttl_untouched/totalno_keys:.2f}')
print(f'Memory may be saved in  21 days: {views_new_memory_saved:.2f} MB Percent:{100.0*views_new_memory_saved/db_size:.2f} ')
print(f'Memory may be saved in 365 days: {sales_new_memory_saved} MB Percent:{100.0*sales_new_memory_saved/db_size} ')
print(f'Size of DB: {db_size_human}B ')
