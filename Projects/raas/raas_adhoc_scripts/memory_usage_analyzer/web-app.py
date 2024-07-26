import streamlit.components as stc 
import redis as r
import pandas as pd
import tqdm
import seaborn as sns
import sys
import pandasql as ps
import streamlit as st 
import base64
import time

#host="getaways-search-cache--redis.staging.stable.us-west-1.aws.groupondev.com"
#host="accounting-service--redis.staging.stable.us-west-1.aws.groupondev.com"
host=st.text_input("Redis DB:")

def csv_downloader(data):
    csv_file=data.to_csv()
    timestr=time.strftime("%Y%m%d-%H%M%S")
    b64 = base64.b64encode(csv_file.encode()).decode()
    new_filename=f"{host}_{timestr}_.csv"
    st.markdown("### Download File ###")
    href = f'<a href="data:file/csv;base64,{b64}" download="{new_filename}">Click Here!!</a>'
    st.markdown(href,unsafe_allow_html=True)

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
            elif(typ=='zset'):
                pipe.zcard(key);
            elif(typ=='list'):
                pipe.llen(key);
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

def main():
    if st.button('Analyze'):
        st.text(host)
        conn1=r.Redis(host,6379,0)

        keyname=[ key.decode('utf8') for key in (conn1.scan_iter(count=500_000)) ]
        output_ttl=run_in_pipe(conn1,200_000,keyname,'ttl(')
        output_type1=run_in_pipe(conn1,200_000,keyname,'type(')
        output_type=[ x.decode('utf8') for x in output_type1 ]
        del output_type1
        output_mem=run_in_pipe(conn1,200_000,keyname,'memory_usage(')
        output_idletime=run_in_pipe(conn1,200_000,keyname,"object('idletime',")
        output_len1=run_in_pipe2(conn1,200_000,keyname,output_type)
        output_len=list_bytes_to_str(output_len1)
        del output_len1
        print(len(keyname),len(output_ttl),len(output_type),len(output_mem),len(output_idletime),len(output_len))
        df1=pd.DataFrame(data=list(zip(keyname,output_ttl,output_type,output_mem,output_idletime,output_len)),columns=['keys','ttl','type','memory','idletime','length'])
        del keyname,output_ttl,output_type,output_mem,output_idletime,output_len


        df2=ps.sqldf("select keys, ttl, type, memory as mem_bytes, idletime/(24*3600) idle_days, length from df1")
        df2.to_csv('output.csv',header=True,index=False)
        #df2=pd.read_csv('output.csv')
        st.text("Sample keys")
        st.dataframe(df2[['keys','ttl','type','mem_bytes','idle_days','length']].head(50))
        st.text("Total no of keys")
        st.text(len(df2))
        st.text("Data types used")
        st.dataframe(ps.sqldf('select type, sum(mem_bytes)/(1024*1024) mem_mb, count(*) "No of keys" from df2 group by 1 order by 1 '))
        st.text("Top Bigkeys")
        st.dataframe(ps.sqldf('select * from df2 order by length desc limit 50'))
        st.text("Top Memkeys")
        st.dataframe(ps.sqldf('select * from df2 order by mem_bytes desc limit 50'))
        st.text("Top Idlekeys")
        st.dataframe(ps.sqldf('select * from df2 order by idle_days desc limit 50'))
        
        #csv_downloader(df2[['keys','ttl','type','mem_bytes','idle_days','length']])
    

if __name__ == '__main__':
    main()

