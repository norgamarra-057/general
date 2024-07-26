import redis as r

scancount=50_000

source_hostname='raas-pool10.snc1'
source_port    =6380
source_db      =0

target_hostname='raas-pool10.snc1'
target_port    =6381
target_db      =0


source_connection=r.Redis(host=source_hostname,port=source_port,db=source_db)
target_connection=r.Redis(host=target_hostname,port=target_port,db=target_db)


tmp=source_connection.scan(0,count=scancount)
tmp_flag1=0
counter=0
tkeys=source_connection.info(section='keyspace')["db"+str(source_db)]["keys"]

while True:
    for key in range(len(tmp[1])):
        keyname=tmp[1][key].decode("utf-8")
        s_ttl=source_connection.ttl(keyname)
        counter=counter+1
        print(str(counter)+"/"+str(tkeys), end='\r')
        if (s_ttl>=0):
            target_connection.restore(name=keyname,ttl=s_ttl, value=source_connection.dump(keyname), replace=True)
        elif(s_ttl==-1):
            target_connection.restore(name=keyname,ttl=0    , value=source_connection.dump(keyname), replace=True)
    if(tmp[0]==0):
        break       # last loop executed, so exit now
    if(tmp[0]!=0):
        tmp=source_connection.scan(tmp[0],count=scancount)
        continue
