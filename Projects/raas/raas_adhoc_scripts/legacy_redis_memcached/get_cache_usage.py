#!/usr/bin/env python3

"""
No arguments required.
"""

import paramiko 
import os
import sys

f=open(os.devnull,'w')
sys.stderr=f

k = paramiko.RSAKey.from_private_key_file("/Users/ksatyamurthy/.ssh/id_rsa")
c = paramiko.SSHClient()
c.set_missing_host_key_policy(paramiko.AutoAddPolicy())

shell_script="""
gethostname () {

# resolve ip-address to hostname

python <<EOT
import socket

try:
    print socket.gethostbyaddr("${1}")[0]
    # print "${1}" + '\t' + socket.gethostbyaddr("${1}")[0]
except Exception:
    print '${1}'
    # print "${1}" + '\t' + 'NXDOMAIN'
    
EOT
}

get_logged_port_messages() {
# 1 argument, port no like, 6379, 11211, 3306 etc
port_no="$1"

for ip in `{ sudo zcat /var/log/messages-2022*.gz | grep DPT=${port_no}; sudo cat /var/log/messages | grep DPT=${port_no}; } | egrep -o 'SRC=[0-9.]+ '| sort | uniq | awk -F= '{ print $2 }'`
do
# echo $ip
gethostname $ip
done

}

if [[ `hostname -f | grep -c redis` -eq 1 ]]
then
export PROCESS_NAME="redis-server"
elif [[ `hostname -f | grep -c memcache` -eq 1 ]]
then
export PROCESS_NAME="memcached"
fi


get_my_process_ports() {
# 1 argument, process name
# Examples: redis-server, memcached
for x in `pgrep $1`
do
port_no=`sudo lsof -P -p $x | grep LISTEN | awk '{ print $9 }' | awk -F: '{ print $2 }' | sort | uniq `
if [ -n "$port_no" ]; then 
echo "$port_no"
fi
done 
}

for x in `get_my_process_ports $PROCESS_NAME`
do
get_logged_port_messages $x
done | sort | uniq 

"""

redis_hosts_staging=['cadence-arbitration-redis4-staging.snc1','finch-redis1-staging.snc1','finch-redis5-staging.snc1','finch-redis6-staging.snc1','general-redis1-staging.snc1','general-redis3-staging.snc1','general-redis4-staging.snc1','goodsci-redis1-staging.snc1','goods-redis1-staging.snc1','goods-stores-redis1-staging.snc1','list-service-redis1-staging.snc1','list-service-redis2-staging.snc1','list-service-redis3-staging.snc1','list-service-redis4-staging.snc1','merchant-data-dora-redis1-staging.snc1','merchant-data-dora-redis2-staging.snc1','orders-txnstore-redis1-emea-staging.snc1','quantum-lead-redis1-staging.snc1','rocketman-redis1-emea-staging.snc1','seo-services-redis1-staging.snc1','seo-services-redis2-staging.snc1','seo-services-redis3-staging.snc1','supply-chain-gateway-redis1-staging.snc1','voucher-inventory-redis1-emea-staging.snc1','voucher-inventory-redis2-emea-staging.snc1']
redis_hosts_uat=['email-campaign-uat-redis.snc1','external-tracking-redis1-uat.snc1','general-redis3-uat.snc1','general-redis4-uat.snc1','list-service-redis1-uat.snc1','merchant-data-dora-redis1-uat.snc1','seo-services-redis1-uat.snc1','seo-services-redis2-uat.snc1','seo-services-redis3-uat.snc1','supply-chain-gateway-redis1-uat.snc1','transporter-redis1-uat.snc1','uis-redis1-uat.snc1']
memcache_hosts_staging=['accounting-memcache1-staging.snc1','booking-engine-3rd-party-memcache1-emea-staging.snc1','booking-engine-3rd-party-memcache2-emea-staging.snc1','booking-engine-3rd-party-memcached1-staging.snc1','booking-engine-3rd-party-memcached2-staging.snc1','booking-engine-api-memcached1-staging.snc1','booking-engine-appointments-memcached1-emea-staging.snc1','booking-engine-appointments-memcached1-staging.snc1','booking-engine-appointments-memcached2-emea-staging.snc1','booking-engine-appointments-memcached2-staging.snc1','geo-taxonomy-memcached1-staging.snc1','geo-taxonomy-memcached2-staging.snc1','goodscentral-memcache1-staging.snc1','goodscentral-memcache2-staging.snc1','goods-memcache1-emea-staging.snc1','goods-memcache1-staging.snc1','goods-memcache2-staging.snc1','goods-outbound-controller-emea-memcache1-staging.snc1','goods-outbound-controller-memcache1-staging.snc1','merchant-self-service-engine-memcache1-staging.snc1','mpp-service-memcache1-staging.snc1','orders-memcache1-emea-staging.snc1','users-service-memcache1-emea-staging.snc1','users-service-memcache1-staging.snc1','voucher-inventory-memcache1-emea-staging.snc1','voucher-inventory-memcache1-staging.snc1','voucher-inventory-memcache2-emea-staging.snc1','voucher-inventory-memcache2-staging.snc1','web-memcache1-staging.snc1']
memcache_hosts_uat=['accounting-memcache1-uat.snc1','booking-engine-3rd-party-memcached1-uat.snc1','booking-engine-appointments-memcached1-uat.snc1','geo-taxonomy-memcached1-uat.snc1','geo-taxonomy-memcached2-uat.snc1','geo-taxonomy-memcached3-uat.snc1','mpp-service-memcache1-uat.snc1','users-service-memcache1-uat.snc1','voucher-inventory-memcache1-emea-uat.snc1','voucher-inventory-memcache1-uat.snc1','voucher-inventory-memcache2-emea-uat.snc1','voucher-inventory-memcache2-uat.snc1']

all_hosts=redis_hosts_staging + redis_hosts_uat + memcache_hosts_staging + memcache_hosts_uat

# hosts=['booking-engine-3rd-party-memcache1-emea-staging.snc1']

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
        tmpstring=cmd_output1.rstrip('\n').replace('\n',',').replace('|','')
        tmpset=set(tmpstring.split(','))
        if(hostx in tmpset):
            # print("INFO: same hostname")
            tmpset.remove(hostx)
            tmpset.add('localhost')
        tmplist=list(tmpset)
        tmplist.sort()
        cmd_output2=','.join(tmplist)

        # cmd_output2=cmd_output1.replace('\n',',').replace('|','')
        err_output2=err_output1.replace('\n','').replace('|','')


        print(f"""{hostx}|{cmd_output2}|{err_output2}|{return_code1}""")
    except Exception as e:
        print(f"""{hostx}|-|{e}|255""")


