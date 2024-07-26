import sys
import redis as r
import pandas as pd
import pandasql as ps
from datetime import datetime
import time
import tqdm
import os
import pathlib
import shutil
import gzip
import seaborn as sns

mode="test" # test, prod
dbname="mppservice-cache"
hostname="redis-13029.sac1.raas-shared2-prod.grpn"
port=13029
db=0
scan_buffer_size=5000
dbpath=f'/home/ksatyamurthy/mpp/{dbname}'
pathlib.Path(dbpath).mkdir(parents=True, exist_ok=True) 

def t(input):
    print(input + " " + datetime.now().strftime("%Y-%m-%d %H:%M:%S"))


def gzip_file(in_file):
    in_data = open(in_file, "rb").read()
    out_gz = in_file + ".gz"
    gzf = gzip.open(out_gz, "wb")
    gzf.write(in_data)
    gzf.close()
    os.unlink(in_file)
    
def guzip_file(in_file):
    with gzip.open(in_file + 'gzip', 'rb') as f_in:
        with open(in_file.replace('.gz',''), 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)
            os.unlink(in_file)
            
def scan_keys(hostname,portno,db,scancount):
    keys_names=[]
    keys_ttls=[]
    keys_idletime=[]
    keys_memoryusage=[]
    keys_type=[]
    rc=r.Redis(host=hostname,port=portno,db=db)
    print("Connected to redis")
    total_no_of_keys=rc.info()['db0']['keys']
    tmp=rc.scan(0,count=scancount)
    tmp_processed_keys=0
    tmp_flag1=0
    while True:
        print(tmp[0])
        tmp_processed_keys=tmp_processed_keys+len(tmp[1])
        vartime=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        tmp_ppercent=f'{100*tmp_processed_keys/total_no_of_keys:.2f}'.rjust(6,' ')
        print(f"  At {vartime} scanned: {tmp_processed_keys:>10} which is {tmp_ppercent}% of keys ({total_no_of_keys})")
        for key in tqdm.tqdm(range(len(tmp[1]))):
            keyname=tmp[1][key].decode("utf-8")
            keys_names.append(keyname)
            keys_ttls.append(rc.ttl(keyname))
            keys_idletime.append(rc.object("idletime",keyname))
            keys_memoryusage.append(rc.memory_usage(keyname))
            keys_type.append(rc.type(keyname).decode("utf-8"))
        if(tmp_flag1==1):
            break
        tmp=rc.scan(tmp[0],count=scancount)
        if(tmp[0] == 0 and tmp_flag1==0):
            tmp_flag1=1  # Execute the last loop
    print("Scanning completed")
    data_tuples=list(zip(keys_names,keys_ttls,keys_idletime,keys_memoryusage,keys_type))
    keys_info=pd.DataFrame(data_tuples, columns=['name','ttl','idletime','memory_usage','type'])
    return keys_info
	
keynames=scan_keys(hostname,port,db,scan_buffer_size)
keynames.shape
