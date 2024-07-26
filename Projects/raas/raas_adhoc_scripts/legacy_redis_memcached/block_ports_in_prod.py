#!/usr/bin/env python3

"""
No arguments required.
"""

import paramiko 
import os
import sys
import time

f=open(os.devnull,'w')
sys.stderr=f

k = paramiko.RSAKey.from_private_key_file("/Users/ksatyamurthy/.ssh/id_rsa")
c = paramiko.SSHClient()
c.set_missing_host_key_policy(paramiko.AutoAddPolicy())

shell_script="""

reject_port() {
# 1 argument, port no like, 6379, 11211, 3306 etc
# using iptables to block ports
download_encap iptables-1.4.13 >/dev/null 2>&1
export PATH="$PATH:/usr/local/sbin/:/sbin/:/packages/encap/iptables-1.4.13/sbin"

port_no="$1"

if [ -n "$port_no" ]; then 
    if  [[ `sudo iptables -L INPUT --line-numbers --numeric |  grep ":${port_no}" | grep "REJECT" | wc -l ` -eq 0 ]]; then 
        sudo iptables -I INPUT -p tcp --dport $port_no -j REJECT
        if [[ $? -eq 0 ]]; then 
            echo "iptables ${port_no}: reject rule applied successfully"
        else
            echo "iptables ${port_no}: reject rule apply failed"
        fi
    else
            echo "iptables ${port_no}: reject rule already exists"
    fi

    else
        echo "Provide an argument"
fi
}

get_my_process_ports() {
# 1 argument, process name
# Examples: redis-server, memcached

download_encap lsof-4.85  >/dev/null 2>&1
export PATH="$PATH:/usr/local/sbin/:/sbin/:/packages/encap/lsof-4.85/bin/"


for x in `pgrep $1`
do
port_no=`sudo /packages/encap/lsof-4.85/bin/lsof -P -p $x | grep LISTEN | awk '{ print $9 }' | awk -F: '{ print $2 }' | sort | uniq `
if [ -n "$port_no" ]; then 
echo "$port_no"
fi
done 
}


if [[ `hostname -f | grep -c redis` -eq 1 ]]
then
  PROCESS_NAME="redis-server"
elif [[ `hostname -f | grep -c memcache` -eq 1 ]]
then
  PROCESS_NAME="memcached"
fi

var=`get_my_process_ports $PROCESS_NAME | wc -l `

if [[ $var -eq 0 ]]; then
    echo "No process found!"
else 
    for x in `get_my_process_ports $PROCESS_NAME`
    do
    reject_port $x
    done 
fi



"""

# all_hosts=['orders-memcache1.snc1','orders-memcache3.snc1','accounting-memcache1.snc1','accounting-memcache2.snc1','accounting-memcache3.snc1','finch-redis1.snc1','finch-redis2.snc1','finch-redis3.snc1','finch-redis4.snc1','goods-memcache.snc1','goods-memcache1.snc1','goods-memcache3.snc1','geo-taxonomy-memcached1.dub1','geo-taxonomy-memcached1.sac1','geo-taxonomy-memcached1.snc1','geo-taxonomy-memcached2.dub1','geo-taxonomy-memcached2.sac1','geo-taxonomy-memcached2.snc1','geo-taxonomy-memcached3.dub1','geo-taxonomy-memcached3.snc1','geo-taxonomy-memcached4.dub1','geo-taxonomy-memcached4.snc1','itier-getaways-extranet-memcache-app1.sac1','itier-getaways-extranet-memcache-app2.sac1','booking-engine-3rd-party-memcached1.dub1','booking-engine-3rd-party-memcached1.sac1','booking-engine-3rd-party-memcached1.snc1','booking-engine-3rd-party-memcached2.dub1','booking-engine-3rd-party-memcached2.sac1','booking-engine-3rd-party-memcached2.snc1','booking-engine-api-memcached1.sac1','booking-engine-api-memcached1.snc1','booking-engine-api-memcached2.sac1','booking-engine-api-memcached2.snc1','booking-engine-appointments-memcached1.dub1','general-redis2.snc1','badges-redis2.dub1']
# all_hosts=['orders-memcache1.snc1','orders-memcache3.snc1','accounting-memcache1.snc1','accounting-memcache2.snc1','accounting-memcache3.snc1','goods-memcache.snc1','geo-taxonomy-memcached1.dub1','geo-taxonomy-memcached1.sac1','geo-taxonomy-memcached2.dub1','geo-taxonomy-memcached2.sac1','geo-taxonomy-memcached3.dub1','geo-taxonomy-memcached4.dub1','itier-getaways-extranet-memcache-app1.sac1','itier-getaways-extranet-memcache-app2.sac1','booking-engine-3rd-party-memcached1.sac1','booking-engine-3rd-party-memcached2.snc1','booking-engine-api-memcached1.sac1','booking-engine-api-memcached2.sac1','general-redis2.snc1','badges-redis2.dub1']
all_hosts=['finch-redis1.snc1','finch-redis2.snc1','finch-redis3.snc1','finch-redis4.snc1','goods-memcache1.snc1','goods-memcache3.snc1','geo-taxonomy-memcached1.snc1','geo-taxonomy-memcached2.snc1','geo-taxonomy-memcached3.snc1','geo-taxonomy-memcached4.snc1','booking-engine-api-memcached1.snc1','booking-engine-api-memcached2.snc1']

print(f"""hostname|stdout|stderr|return_code""")

for hostx in all_hosts:
    try:
        c.connect( hostname = hostx, username = "ksatyamurthy", pkey = k, timeout=20)
        stdin , stdout, stderr = c.exec_command(shell_script)
        cmd_output1=stdout.read().decode()
        return_code1=stdout.channel.recv_exit_status()
        err_output1=stderr.read().decode()
        stdin.close()
        c.close()

        # to remove duplicate hostnames, rename to localhost
        # tmpstring=cmd_output1.rstrip('\n').replace('\n',',').replace('|','')
        # tmpset=set(tmpstring.split(','))
        # if(hostx in tmpset):
        #     # print("INFO: same hostname")
        #     tmpset.remove(hostx)
        #     tmpset.add('localhost')
        # tmplist=list(tmpset)
        # tmplist.sort()
        # cmd_output2=','.join(tmplist)

        cmd_output2=cmd_output1.rstrip('\n').replace('\n',',').replace('|','')
        err_output2=err_output1.replace('\n','').replace('|','')


        print(f"""{hostx}|{cmd_output2}|{err_output2}|{return_code1}""")
        time.sleep(1)
    except Exception as e:
        print(f"""{hostx}|-|{e}|255""")


