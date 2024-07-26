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

download_encap iptables-1.4.13 >/dev/null 2>&1
export PATH="$PATH:/usr/local/sbin/:/sbin/:/packages/encap/iptables-1.4.13/sbin"

while [[ `sudo iptables -L INPUT --line-numbers --numeric | grep LOG | wc -l ` -ne 0  ]]
do
value=`sudo iptables -L INPUT --line-numbers --numeric | grep LOG | head -1 | awk '{ print $1 }'`
sudo iptables -D INPUT $value

if [[ "$?" -eq 0 ]]; then
echo "LOG rule deleted"
fi
# sleep 2
done

"""

# staging_hosts=['accounting-memcache1-staging.snc1','accounting-memcache1-uat.snc1','booking-engine-3rd-party-memcache1-emea-staging.snc1','booking-engine-3rd-party-memcache2-emea-staging.snc1','booking-engine-3rd-party-memcached1-staging.snc1','booking-engine-3rd-party-memcached1-uat.snc1','booking-engine-3rd-party-memcached2-staging.snc1','booking-engine-api-memcached1-staging.snc1','booking-engine-appointments-memcached1-emea-staging.snc1','booking-engine-appointments-memcached1-staging.snc1','booking-engine-appointments-memcached1-uat.snc1','booking-engine-appointments-memcached2-emea-staging.snc1','booking-engine-appointments-memcached2-staging.snc1','cadence-arbitration-redis4-staging.snc1','email-campaign-uat-redis.snc1','external-tracking-redis1-uat.snc1','finch-redis1-staging.snc1','general-redis3-staging.snc1','general-redis3-uat.snc1','general-redis4-staging.snc1','general-redis4-uat.snc1','geo-taxonomy-memcached1-staging.snc1','geo-taxonomy-memcached1-uat.snc1','geo-taxonomy-memcached2-staging.snc1','geo-taxonomy-memcached2-uat.snc1','geo-taxonomy-memcached3-uat.snc1','goods-memcache1-emea-staging.snc1','goods-memcache1-staging.snc1','goods-memcache2-staging.snc1','goods-outbound-controller-emea-memcache1-staging.snc1','goods-outbound-controller-memcache1-staging.snc1','goods-redis1-staging.snc1','goods-stores-redis1-staging.snc1','goodscentral-memcache1-staging.snc1','goodscentral-memcache2-staging.snc1','goodsci-redis1-staging.snc1','list-service-redis1-staging.snc1','list-service-redis1-uat.snc1','list-service-redis2-staging.snc1','list-service-redis3-staging.snc1','list-service-redis4-staging.snc1','merchant-self-service-engine-memcache1-staging.snc1','mpp-service-memcache1-staging.snc1','mpp-service-memcache1-uat.snc1','orders-memcache1-emea-staging.snc1','orders-txnstore-redis1-emea-staging.snc1','supply-chain-gateway-redis1-staging.snc1','supply-chain-gateway-redis1-uat.snc1','transporter-redis1-uat.snc1','uis-redis1-uat.snc1','users-service-memcache1-emea-staging.snc1','users-service-memcache1-staging.snc1','users-service-memcache1-uat.snc1','voucher-inventory-memcache1-emea-staging.snc1','voucher-inventory-memcache1-emea-uat.snc1','voucher-inventory-memcache1-staging.snc1','voucher-inventory-memcache1-uat.snc1','voucher-inventory-memcache2-emea-staging.snc1','voucher-inventory-memcache2-emea-uat.snc1','voucher-inventory-memcache2-staging.snc1','voucher-inventory-memcache2-uat.snc1','voucher-inventory-redis1-emea-staging.snc1','voucher-inventory-redis2-emea-staging.snc1','web-memcache1-staging.snc1']
# hosts=['booking-engine-3rd-party-memcache1-emea-staging.snc1']
# all_hosts=['cadence-arbitration-redis4-staging.snc1','finch-redis1-staging.snc1','general-redis3-staging.snc1','general-redis4-staging.snc1','goodsci-redis1-staging.snc1','goods-redis1-staging.snc1','goods-stores-redis1-staging.snc1','list-service-redis1-staging.snc1','list-service-redis2-staging.snc1','list-service-redis3-staging.snc1','list-service-redis4-staging.snc1','orders-txnstore-redis1-emea-staging.snc1','supply-chain-gateway-redis1-staging.snc1','voucher-inventory-redis1-emea-staging.snc1','email-campaign-uat-redis.snc1','external-tracking-redis1-uat.snc1','general-redis3-uat.snc1','list-service-redis1-uat.snc1','supply-chain-gateway-redis1-uat.snc1','transporter-redis1-uat.snc1','uis-redis1-uat.snc1','booking-engine-3rd-party-memcache1-emea-staging.snc1','booking-engine-3rd-party-memcache2-emea-staging.snc1','booking-engine-3rd-party-memcached1-staging.snc1','booking-engine-3rd-party-memcached2-staging.snc1','booking-engine-api-memcached1-staging.snc1','geo-taxonomy-memcached1-staging.snc1','geo-taxonomy-memcached2-staging.snc1','goodscentral-memcache1-staging.snc1','goodscentral-memcache2-staging.snc1','goods-memcache1-emea-staging.snc1','goods-memcache1-staging.snc1','goods-memcache2-staging.snc1','goods-outbound-controller-emea-memcache1-staging.snc1','goods-outbound-controller-memcache1-staging.snc1','mpp-service-memcache1-staging.snc1','voucher-inventory-memcache1-emea-staging.snc1','voucher-inventory-memcache1-staging.snc1','voucher-inventory-memcache2-emea-staging.snc1','voucher-inventory-memcache2-staging.snc1','booking-engine-3rd-party-memcached1-uat.snc1','booking-engine-appointments-memcached1-uat.snc1','geo-taxonomy-memcached1-uat.snc1','geo-taxonomy-memcached2-uat.snc1','geo-taxonomy-memcached3-uat.snc1','mpp-service-memcache1-uat.snc1','users-service-memcache1-uat.snc1','voucher-inventory-memcache1-emea-uat.snc1','voucher-inventory-memcache1-uat.snc1','voucher-inventory-memcache2-emea-uat.snc1','voucher-inventory-memcache2-uat.snc1']
# all_hosts=['finch-redis1.snc1','finch-redis2.snc1','web-session-memcache1.snc1','finch-redis3.snc1','finch-redis4.snc1','general-redis1.snc1','general-redis2.snc1','quantum-lead-redis2.snc1','transporter-redis1.snc1','transporter-redis2.snc1','badges-redis2.dub1','goods-redis1.dub1','rocketman-redis1.dub1','rocketman-redis2.dub1','seo-services-redis1.dub1','seo-services-redis2.dub1','seo-services-redis3.dub1','accounting-memcache1.sac1','accounting-memcache1.snc1','accounting-memcache2.sac1','accounting-memcache2.snc1','accounting-memcache3.sac1','accounting-memcache3.snc1','booking-engine-3rd-party-memcached1.dub1','booking-engine-3rd-party-memcached1.sac1','booking-engine-3rd-party-memcached1.snc1','booking-engine-3rd-party-memcached2.dub1','booking-engine-3rd-party-memcached2.sac1','booking-engine-3rd-party-memcached2.snc1','booking-engine-api-memcached1.sac1','booking-engine-api-memcached1.snc1','booking-engine-api-memcached2.sac1','booking-engine-api-memcached2.snc1','booking-engine-appointments-memcached1.dub1','booking-engine-appointments-memcached1.sac1','booking-engine-appointments-memcached1.snc1','booking-engine-appointments-memcached2.dub1','booking-engine-appointments-memcached2.sac1','booking-engine-appointments-memcached2.snc1','geo-taxonomy-memcached1.dub1','geo-taxonomy-memcached1.sac1','geo-taxonomy-memcached1.snc1','geo-taxonomy-memcached2.dub1','geo-taxonomy-memcached2.sac1','geo-taxonomy-memcached2.snc1','geo-taxonomy-memcached3.dub1','geo-taxonomy-memcached3.snc1','geo-taxonomy-memcached4.dub1','geo-taxonomy-memcached4.snc1','goods-memcache1.dub1','goods-memcache1.snc1','goods-memcache2.dub1','goods-memcache2.snc1','goods-memcache3.snc1','goods-memcache.snc1','itier-getaways-extranet-memcache-app1.sac1','itier-getaways-extranet-memcache-app1.snc1','itier-getaways-extranet-memcache-app2.sac1','itier-getaways-extranet-memcache-app2.snc1','orders-memcache1.dub1','orders-memcache1.sac1','orders-memcache1.snc1','orders-memcache2.dub1','orders-memcache2.sac1','orders-memcache3.snc1','users-service-memcache1.dub1','users-service-memcache1.sac1','users-service-memcache1.snc1','users-service-memcache2.dub1','users-service-memcache2.sac1','users-service-memcache2.snc1','users-service-memcache3.snc1','web-general-memcache1.snc1','web-general-memcache2.snc1','web-general-memcache3.snc1','web-general-memcache4.snc1']
# all_hosts=['finch-redis1.snc1','finch-redis2.snc1','web-session-memcache1.snc1','finch-redis3.snc1','finch-redis4.snc1','general-redis1.snc1','general-redis2.snc1','badges-redis2.dub1','rocketman-redis1.dub1','rocketman-redis2.dub1','seo-services-redis1.dub1','seo-services-redis2.dub1','seo-services-redis3.dub1','accounting-memcache1.sac1','accounting-memcache1.snc1','accounting-memcache2.sac1','accounting-memcache2.snc1','accounting-memcache3.sac1','accounting-memcache3.snc1','booking-engine-3rd-party-memcached1.dub1','booking-engine-3rd-party-memcached1.sac1','booking-engine-3rd-party-memcached1.snc1','booking-engine-3rd-party-memcached2.dub1','booking-engine-3rd-party-memcached2.sac1','booking-engine-3rd-party-memcached2.snc1','booking-engine-api-memcached1.sac1','booking-engine-api-memcached1.snc1','booking-engine-api-memcached2.sac1','booking-engine-api-memcached2.snc1','booking-engine-appointments-memcached1.dub1','booking-engine-appointments-memcached1.sac1','booking-engine-appointments-memcached1.snc1','booking-engine-appointments-memcached2.sac1','booking-engine-appointments-memcached2.snc1','geo-taxonomy-memcached1.dub1','geo-taxonomy-memcached1.sac1','geo-taxonomy-memcached1.snc1','geo-taxonomy-memcached2.dub1','geo-taxonomy-memcached2.sac1','geo-taxonomy-memcached2.snc1','geo-taxonomy-memcached3.dub1','geo-taxonomy-memcached3.snc1','geo-taxonomy-memcached4.dub1','geo-taxonomy-memcached4.snc1','goods-memcache1.snc1','goods-memcache3.snc1','goods-memcache.snc1','itier-getaways-extranet-memcache-app1.sac1','itier-getaways-extranet-memcache-app1.snc1','itier-getaways-extranet-memcache-app2.sac1','itier-getaways-extranet-memcache-app2.snc1','orders-memcache1.dub1','orders-memcache1.snc1','orders-memcache2.dub1','orders-memcache3.snc1','users-service-memcache1.dub1','users-service-memcache1.sac1','users-service-memcache1.snc1','users-service-memcache2.dub1','users-service-memcache2.sac1','users-service-memcache2.snc1','users-service-memcache3.snc1','web-general-memcache1.snc1','web-general-memcache2.snc1','web-general-memcache3.snc1','web-general-memcache4.snc1']

# these hosts got legitimate traffic we can stop logging these hosts.
disable_logging=['users-service-memcache1.sac1','users-service-memcache2.sac1','users-service-memcache1.dub1','users-service-memcache2.dub1','seo-services-redis3.dub1','orders-memcache1.dub1','orders-memcache2.dub1','web-session-memcache1.snc1','users-service-memcache1.snc1','users-service-memcache2.snc1','users-service-memcache3.snc1','seo-services-redis2.dub1','rocketman-redis1.dub1','rocketman-redis2.dub1','web-general-memcache2.snc1','web-general-memcache3.snc1','web-general-memcache4.snc1','seo-services-redis1.dub1','itier-getaways-extranet-memcache-app1.snc1','itier-getaways-extranet-memcache-app2.snc1','general-redis1.snc1','booking-engine-appointments-memcached1.sac1','booking-engine-appointments-memcached1.snc1','booking-engine-appointments-memcached2.sac1','booking-engine-appointments-memcached2.snc1','accounting-memcache1.sac1','accounting-memcache2.sac1','accounting-memcache3.sac1']

print(f"""hostname|stdout|stderr|return_code""")

for hostx in disable_logging:
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
        # time.sleep(1)
    except Exception as e:
        print(f"""{hostx}|-|{e}|255""")


