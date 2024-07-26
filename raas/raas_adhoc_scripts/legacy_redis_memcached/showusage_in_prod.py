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

# sudo find /var/log/messages*.gz -type f -mtime +14 -delete

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

for x in `get_my_process_ports $PROCESS_NAME`
do
get_logged_port_messages $x
done | sort | uniq 

"""

# all_hosts=['finch-redis1.snc1','finch-redis2.snc1','web-session-memcache1.snc1','finch-redis3.snc1','finch-redis4.snc1','general-redis1.snc1','general-redis2.snc1','quantum-lead-redis2.snc1','transporter-redis1.snc1','transporter-redis2.snc1','badges-redis2.dub1','goods-redis1.dub1','rocketman-redis1.dub1','rocketman-redis2.dub1','seo-services-redis1.dub1','seo-services-redis2.dub1','seo-services-redis3.dub1','accounting-memcache1.sac1','accounting-memcache1.snc1','accounting-memcache2.sac1','accounting-memcache2.snc1','accounting-memcache3.sac1','accounting-memcache3.snc1','booking-engine-3rd-party-memcached1.dub1','booking-engine-3rd-party-memcached1.sac1','booking-engine-3rd-party-memcached1.snc1','booking-engine-3rd-party-memcached2.dub1','booking-engine-3rd-party-memcached2.sac1','booking-engine-3rd-party-memcached2.snc1','booking-engine-api-memcached1.sac1','booking-engine-api-memcached1.snc1','booking-engine-api-memcached2.sac1','booking-engine-api-memcached2.snc1','booking-engine-appointments-memcached1.dub1','booking-engine-appointments-memcached1.sac1','booking-engine-appointments-memcached1.snc1','booking-engine-appointments-memcached2.dub1','booking-engine-appointments-memcached2.sac1','booking-engine-appointments-memcached2.snc1','geo-taxonomy-memcached1.dub1','geo-taxonomy-memcached1.sac1','geo-taxonomy-memcached1.snc1','geo-taxonomy-memcached2.dub1','geo-taxonomy-memcached2.sac1','geo-taxonomy-memcached2.snc1','geo-taxonomy-memcached3.dub1','geo-taxonomy-memcached3.snc1','geo-taxonomy-memcached4.dub1','geo-taxonomy-memcached4.snc1','goods-memcache1.dub1','goods-memcache1.snc1','goods-memcache2.dub1','goods-memcache2.snc1','goods-memcache3.snc1','goods-memcache.snc1','itier-getaways-extranet-memcache-app1.sac1','itier-getaways-extranet-memcache-app1.snc1','itier-getaways-extranet-memcache-app2.sac1','itier-getaways-extranet-memcache-app2.snc1','orders-memcache1.dub1','orders-memcache1.sac1','orders-memcache1.snc1','orders-memcache2.dub1','orders-memcache2.sac1','orders-memcache3.snc1','users-service-memcache1.dub1','users-service-memcache1.sac1','users-service-memcache1.snc1','users-service-memcache2.dub1','users-service-memcache2.sac1','users-service-memcache2.snc1','users-service-memcache3.snc1','web-general-memcache1.snc1','web-general-memcache2.snc1','web-general-memcache3.snc1','web-general-memcache4.snc1']
# all_hosts=['finch-redis1.snc1','finch-redis2.snc1','web-session-memcache1.snc1','finch-redis3.snc1','finch-redis4.snc1','general-redis1.snc1','general-redis2.snc1','badges-redis2.dub1','rocketman-redis1.dub1','rocketman-redis2.dub1','seo-services-redis1.dub1','seo-services-redis2.dub1','seo-services-redis3.dub1','accounting-memcache1.sac1','accounting-memcache1.snc1','accounting-memcache2.sac1','accounting-memcache2.snc1','accounting-memcache3.sac1','accounting-memcache3.snc1','booking-engine-3rd-party-memcached1.dub1','booking-engine-3rd-party-memcached1.sac1','booking-engine-3rd-party-memcached1.snc1','booking-engine-3rd-party-memcached2.dub1','booking-engine-3rd-party-memcached2.sac1','booking-engine-3rd-party-memcached2.snc1','booking-engine-api-memcached1.sac1','booking-engine-api-memcached1.snc1','booking-engine-api-memcached2.sac1','booking-engine-api-memcached2.snc1','booking-engine-appointments-memcached1.dub1','booking-engine-appointments-memcached1.sac1','booking-engine-appointments-memcached1.snc1','booking-engine-appointments-memcached2.sac1','booking-engine-appointments-memcached2.snc1','geo-taxonomy-memcached1.dub1','geo-taxonomy-memcached1.sac1','geo-taxonomy-memcached1.snc1','geo-taxonomy-memcached2.dub1','geo-taxonomy-memcached2.sac1','geo-taxonomy-memcached2.snc1','geo-taxonomy-memcached3.dub1','geo-taxonomy-memcached3.snc1','geo-taxonomy-memcached4.dub1','geo-taxonomy-memcached4.snc1','goods-memcache1.snc1','goods-memcache3.snc1','goods-memcache.snc1','itier-getaways-extranet-memcache-app1.sac1','itier-getaways-extranet-memcache-app1.snc1','itier-getaways-extranet-memcache-app2.sac1','itier-getaways-extranet-memcache-app2.snc1','orders-memcache1.dub1','orders-memcache1.snc1','orders-memcache2.dub1','orders-memcache3.snc1','users-service-memcache1.dub1','users-service-memcache1.sac1','users-service-memcache1.snc1','users-service-memcache2.dub1','users-service-memcache2.sac1','users-service-memcache2.snc1','users-service-memcache3.snc1','web-general-memcache1.snc1','web-general-memcache2.snc1','web-general-memcache3.snc1','web-general-memcache4.snc1']
# all_hosts=['orders-memcache1.snc1','orders-memcache3.snc1','accounting-memcache1.snc1','accounting-memcache2.snc1','accounting-memcache3.snc1','finch-redis1.snc1','finch-redis2.snc1','finch-redis3.snc1','finch-redis4.snc1','goods-memcache.snc1','goods-memcache1.snc1','goods-memcache3.snc1','geo-taxonomy-memcached1.dub1','geo-taxonomy-memcached1.sac1','geo-taxonomy-memcached1.snc1','geo-taxonomy-memcached2.dub1','geo-taxonomy-memcached2.sac1','geo-taxonomy-memcached2.snc1','geo-taxonomy-memcached3.dub1','geo-taxonomy-memcached3.snc1','geo-taxonomy-memcached4.dub1','geo-taxonomy-memcached4.snc1','itier-getaways-extranet-memcache-app1.sac1','itier-getaways-extranet-memcache-app2.sac1','booking-engine-3rd-party-memcached1.dub1','booking-engine-3rd-party-memcached1.sac1','booking-engine-3rd-party-memcached1.snc1','booking-engine-3rd-party-memcached2.dub1','booking-engine-3rd-party-memcached2.sac1','booking-engine-3rd-party-memcached2.snc1','booking-engine-api-memcached1.sac1','booking-engine-api-memcached1.snc1','booking-engine-api-memcached2.sac1','booking-engine-api-memcached2.snc1','booking-engine-appointments-memcached1.dub1','general-redis2.snc1','badges-redis2.dub1']
# all_hosts=['finch-redis1.snc1','finch-redis2.snc1','finch-redis3.snc1','finch-redis4.snc1','goods-memcache1.snc1','goods-memcache3.snc1','geo-taxonomy-memcached1.snc1','geo-taxonomy-memcached2.snc1','geo-taxonomy-memcached3.snc1','geo-taxonomy-memcached4.snc1','booking-engine-api-memcached1.snc1','booking-engine-api-memcached2.snc1']
all_hosts=['accounting-memcache1-uat.snc1','general-redis4-uat.snc1','merchant-data-dora-redis1-uat.snc1','seo-services-redis1-uat.snc1','seo-services-redis2-uat.snc1','seo-services-redis3-uat.snc1','accounting-memcache1-staging.snc1','booking-engine-appointments-memcached1-emea-staging.snc1','booking-engine-appointments-memcached1-staging.snc1','booking-engine-appointments-memcached2-emea-staging.snc1','booking-engine-appointments-memcached2-staging.snc1','general-redis1-staging.snc1','merchant-data-dora-redis1-staging.snc1','merchant-data-dora-redis2-staging.snc1','merchant-self-service-engine-memcache1-staging.snc1','orders-memcache1-emea-staging.snc1','quantum-lead-redis1-staging.snc1','rocketman-redis1-emea-staging.snc1','seo-services-redis1-staging.snc1','seo-services-redis2-staging.snc1','seo-services-redis3-staging.snc1','users-service-memcache1-emea-staging.snc1','voucher-inventory-redis2-emea-staging.snc1','web-memcache1-staging.snc1','accounting-memcache1.sac1','accounting-memcache1.snc1','accounting-memcache2.sac1','accounting-memcache2.snc1','accounting-memcache3.sac1','accounting-memcache3.snc1','booking-engine-3rd-party-memcached1.snc1','booking-engine-3rd-party-memcached2.sac1','booking-engine-appointments-memcached1.sac1','booking-engine-appointments-memcached1.snc1','booking-engine-appointments-memcached2.sac1','booking-engine-appointments-memcached2.snc1','general-redis1.snc1','general-redis2.snc1','geo-taxonomy-memcached1.dub1','geo-taxonomy-memcached1.sac1','geo-taxonomy-memcached1.snc1','geo-taxonomy-memcached2.dub1','geo-taxonomy-memcached2.sac1','geo-taxonomy-memcached2.snc1','geo-taxonomy-memcached3.dub1','geo-taxonomy-memcached3.snc1','geo-taxonomy-memcached4.dub1','geo-taxonomy-memcached4.snc1','goodscentral-memcache1.sac1','goodscentral-memcache2.sac1','goods-memcache1.dub1','goods-memcache2.dub1','goods-memcache2.snc1','goods-outbound-controller-memcache1.dub1','goods-outbound-controller-memcache1.sac1','goods-outbound-controller-memcache1.snc1','goods-outbound-controller-memcache2.dub1','goods-outbound-controller-memcache2.sac1','goods-outbound-controller-memcache2.snc1','goods-redis1.dub1','itier-getaways-extranet-memcache-app1.snc1','itier-getaways-extranet-memcache-app2.snc1','merchant-self-service-engine-memcache1.sac1','merchant-self-service-engine-memcache1.snc1','merchant-self-service-engine-memcache2.sac1','merchant-self-service-engine-memcache2.snc1','merchant-self-service-engine-memcache3.snc1','ogdwall-memcache1-dev.snc1','ogdwall-memcache1.dub1','ogdwall-memcache1.sac1','ogdwall-memcache2-dev.snc1','ogdwall-memcache2.dub1','ogdwall-memcache3.snc1','ogwall-memcache1.sac1','ogwall-memcache1.snc1','ogwall-memcache2.sac1','ogwall-memcache2.snc1','orders-memcache1.dub1','orders-memcache1.sac1','orders-memcache2.dub1','orders-memcache2.sac1','quantum-lead-redis2.snc1','redis-vmhost12-prod.sac1','redis-vmhost6-prod.sac1','redis-vmhost8-prod.sac1','rocketman-redis1.dub1','rocketman-redis2.dub1','semaphore-redis4.snc1','seo-services-redis1.dub1','seo-services-redis2.dub1','seo-services-redis3.dub1','touch-memcache1.dub1','touch-memcache2.dub1','transporter-redis1.snc1','transporter-redis2.snc1','users-service-memcache1.dub1','users-service-memcache1.sac1','users-service-memcache1.snc1','users-service-memcache2.dub1','users-service-memcache2.sac1','users-service-memcache2.snc1','users-service-memcache3.snc1','voucher-inventory-memcache1.dub1','voucher-inventory-memcache1.sac1','voucher-inventory-memcache1.snc1','voucher-inventory-memcache2.dub1','voucher-inventory-memcache2.sac1','voucher-inventory-memcache2.snc1','web-general-memcache1.snc1','web-general-memcache2.snc1','web-general-memcache3.snc1','web-general-memcache4.snc1','web-session-memcache1.snc1','web-session-memcache2.snc1','booking-engine-appointments-memcached2.dub1','booking-engine-appointments-memcached1.dub1','booking-engine-3rd-party-memcached1.dub1','booking-engine-3rd-party-memcached2.dub1']

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

        # cmd_output2=cmd_output1.rstrip('\n').replace('\n',',').replace('|','')
        err_output2=err_output1.replace('\n','').replace('|','')


        print(f"""{hostx}|{cmd_output2}|{err_output2}|{return_code1}""")
        # time.sleep(1)
    except Exception as e:
        print(f"""{hostx}|-|{e}|255""")


