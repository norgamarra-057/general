#!/usr/bin/env python3

import paramiko
import pandas as pd
import pandasql as ps
import re
import numpy as np
import csv
import sys
import getpass



user_name=getpass.getuser()
raas_cluster_name=sys.argv[1] # "us.raas-shared3-prod.grpn"  
dbname=sys.argv[2]            # 'push-dispatcher-error-handling'
#raas_cluster_name="us.raas-shared3-prod.grpn"

k = paramiko.RSAKey.from_private_key_file(f"/Users/{user_name}/.ssh/id_rsa")
c = paramiko.SSHClient()
c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect( hostname = raas_cluster_name, username = user_name, pkey = k )
stdin , stdout, stderr = c.exec_command('sudo rladmin status shards')

varstr=str(stdout.read())
header=varstr.split('\\n')[1]
rows=varstr.split('\\n')[2:]

columnames=re.findall(r'[A-Z:_]+ *',header)
columnames_length=[len(x) for x in columnames]
columnames_length_sum=list(np.cumsum(columnames_length))
columnames_length_sum.append(0)

columnames_1=[x.strip() for x in columnames]
columnames_2=','.join(columnames_1)

with open(raas_cluster_name + '.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    #print(columnames_2)
    writer.writerow(columnames_2.split(','))
    for xx in range(len(rows)-1):
        _row=''
        for x in range(len(columnames_length_sum)-1):
            if(x==0):
                _row=rows[xx][columnames_length_sum[-1+x]: columnames_length_sum[0+x] ].strip()
            else:
                _row=_row +','+ rows[xx][columnames_length_sum[-1+x]: columnames_length_sum[0+x] ].strip()
        #print(_row)
        writer.writerow(_row.split(','))



# us.raas-shared3-prod.grpn.csv

#raas_cluster_name="us.raas-shared3-prod.grpn"  
#dbname='push-dispatcher-error-handling'


shards=pd.read_csv(f"{raas_cluster_name}.csv")
shards['ID']=shards['ID'].str.replace('redis:','')
shards['NODE']=shards['NODE'].str.replace('node:','')



_tmp1=ps.sqldf(f"""
with k1 as (
select node,sum(case when role='master' then 1 else 0 end) mstr, sum(case when role='slave' then 1 else 0 end) slv, count(id)/2 cnt
from shards where NAME='{dbname}'
group by 1
)
select node,mstr-cnt diff,'master' type from k1 where mstr>cnt
union 
select node,cnt-slv diff,'slave' type from k1 where slv>cnt
""")



tmpfull=ps.sqldf(f"""
select a.name,a.id mid,a.node mnode ,a.role mrole,a.slots mslots,b.id sid,b.node snode,b.role srole
from shards a, shards b, (select '{dbname}' dname) f
where  a.name=f.dname
and b.name=f.dname
and a.slots=b.slots and a.role<>b.role and a.node<>b.node
and a.role='master'
and b.role='slave'
order by a.id
""")


lshards_master=list(_tmp1.query("type == 'master'")['node'])
lshards_slave=list(_tmp1.query("type == 'slave'")['node'])

failover_masters=[]
free_slots={}
for x in lshards_master + lshards_slave:
    free_slots[x]=int(_tmp1.query(f"node == '{x}' ")['diff'])

max_master_failover=0
for i in lshards_master:
    max_master_failover=max_master_failover+free_slots[i]

while_counter=0
while True:
    prev_length=len(failover_masters)
    for m in lshards_master:
        for s in lshards_slave:
            if(free_slots[m]>0 and free_slots[s]<0):
                notinstring=','.join(["'"+x+"'" for x in failover_masters])
                try:
                    fail_this_master=ps.sqldf(f"select mid from tmpfull where mnode = '{m}' and snode='{s}' and mid not in ({notinstring}) limit 1").mid[0]
                    failover_masters.append(fail_this_master)
                    print(f"sudo rladmin failover db {dbname} shard {fail_this_master}")
                    free_slots[m]=free_slots[m]-1
                    free_slots[s]=free_slots[s]+1
                except (IndexError):
                    continue
            else:
                continue
    new_length=len(failover_masters)
    while_counter=while_counter+1
    if(prev_length != new_length or while_counter<10):
        continue
    else:
        break


if(max_master_failover==len(failover_masters)):
    print("Completed...")
else:
    print("In complete list !!")
