"""
JIRA ticket: RAAS-555

This script aids in enabling iptables logging of ports belong to redis and memcached process.
It should be ran from local mac, do not try to run it from snc1 host.

"""



import paramiko
import os
import sys

f=open(os.devnull,'w')
sys.stderr=f

redis_hosts_staging=['cadence-arbitration-redis4-staging.snc1','finch-redis1-staging.snc1','finch-redis5-staging.snc1','finch-redis6-staging.snc1','general-redis1-staging.snc1','general-redis3-staging.snc1','general-redis4-staging.snc1','goodsci-redis1-staging.snc1','goods-redis1-staging.snc1','goods-stores-redis1-staging.snc1','list-service-redis1-staging.snc1','list-service-redis2-staging.snc1','list-service-redis3-staging.snc1','list-service-redis4-staging.snc1','merchant-data-dora-redis1-staging.snc1','merchant-data-dora-redis2-staging.snc1','orders-txnstore-redis1-emea-staging.snc1','quantum-lead-redis1-staging.snc1','rocketman-redis1-emea-staging.snc1','seo-services-redis1-staging.snc1','seo-services-redis2-staging.snc1','seo-services-redis3-staging.snc1','supply-chain-gateway-redis1-staging.snc1','voucher-inventory-redis1-emea-staging.snc1','voucher-inventory-redis2-emea-staging.snc1']
redis_hosts_uat=['cadence-arbitration-redis1-uat.snc1','cadence-arbitration-redis2-uat.snc1','email-campaign-uat-redis.snc1','external-tracking-redis1-uat.snc1','general-redis3-uat.snc1','general-redis4-uat.snc1','list-service-redis1-uat.snc1','merchant-data-dora-redis1-uat.snc1','seo-services-redis1-uat.snc1','seo-services-redis2-uat.snc1','seo-services-redis3-uat.snc1','supply-chain-gateway-redis1-uat.snc1','transporter-redis1-uat.snc1','uis-redis1-uat.snc1']

memcache_hosts_staging=['accounting-memcache1-staging.snc1','booking-engine-3rd-party-memcache1-emea-staging.snc1','booking-engine-3rd-party-memcache2-emea-staging.snc1','booking-engine-3rd-party-memcached1-staging.snc1','booking-engine-3rd-party-memcached2-staging.snc1','booking-engine-api-memcached1-staging.snc1','booking-engine-appointments-memcached1-emea-staging.snc1','booking-engine-appointments-memcached1-staging.snc1','booking-engine-appointments-memcached2-emea-staging.snc1','booking-engine-appointments-memcached2-staging.snc1','geo-taxonomy-memcached1-staging.snc1','geo-taxonomy-memcached2-staging.snc1','goodscentral-memcache1-staging.snc1','goodscentral-memcache2-staging.snc1','goods-memcache1-emea-staging.snc1','goods-memcache1-staging.snc1','goods-memcache2-staging.snc1','goods-outbound-controller-emea-memcache1-staging.snc1','goods-outbound-controller-memcache1-staging.snc1','merchant-self-service-engine-memcache1-staging.snc1','mpp-service-memcache1-staging.snc1','orders-memcache1-emea-staging.snc1','users-service-memcache1-emea-staging.snc1','users-service-memcache1-staging.snc1','voucher-inventory-memcache1-emea-staging.snc1','voucher-inventory-memcache1-staging.snc1','voucher-inventory-memcache2-emea-staging.snc1','voucher-inventory-memcache2-staging.snc1','web-memcache1-staging.snc1']
memcache_hosts_uat=['accounting-memcache1-uat.snc1','booking-engine-3rd-party-memcached1-uat.snc1','booking-engine-appointments-memcached1-uat.snc1','geo-taxonomy-memcached1-uat.snc1','geo-taxonomy-memcached2-uat.snc1','geo-taxonomy-memcached3-uat.snc1','mpp-service-memcache1-uat.snc1','users-service-memcache1-uat.snc1','voucher-inventory-memcache1-emea-uat.snc1','voucher-inventory-memcache1-uat.snc1','voucher-inventory-memcache2-emea-uat.snc1','voucher-inventory-memcache2-uat.snc1']

all_hosts=redis_hosts_staging + redis_hosts_uat + memcache_hosts_staging + memcache_hosts_uat

ip_tables_rules='''
download_encap iptables-1.4.13 >/dev/null 2>&1
export PATH="$PATH:/usr/local/sbin/:/sbin/"


# To reset iptables
# sudo /sbin/service iptables restart >/dev/null 2>&1
# sleep 1

if [[ `hostname -f | grep -c redis` -eq 1 ]]
then
  PROCESS_NAME="redis-server"
elif [[ `hostname -f | grep -c memcache` -eq 1 ]]
then
  PROCESS_NAME="memcached"
fi

for x in `pgrep $PROCESS_NAME`
do
port_no=`sudo lsof -P -p $x | grep LISTEN | awk '{ print $9 }' | awk -F: '{ print $2 }' | sort | uniq `
if [ -n "$port_no" ]; then 
sudo iptables -L INPUT --line-numbers --numeric | grep "$port_no"
fi
done | wc -l 
'''

ip_tables_logging_port='''
export PATH="$PATH:/usr/local/sbin/:/sbin/"

if [[ `hostname -f | grep -c redis` -eq 1 ]]
then
  PROCESS_NAME="redis-server"
elif [[ `hostname -f | grep -c memcache` -eq 1 ]]
then
  PROCESS_NAME="memcached"
fi



for x in `pgrep $PROCESS_NAME`
do
port_no=`sudo lsof -P -p $x | grep LISTEN | awk '{ print $9 }' | awk -F: '{ print $2 }' | sort | uniq `
if [ -n "$port_no" ]; then 
echo "Port: $port_no"
sudo iptables -I INPUT -p tcp -m tcp --dport $port_no -m state --state NEW  -j LOG --log-level 1 --log-prefix "${PROCESS_NAME}-new-connection:"
fi
done
'''

k = paramiko.RSAKey.from_private_key_file("/Users/ksatyamurthy/.ssh/id_rsa")
c = paramiko.SSHClient()
c.set_missing_host_key_policy(paramiko.AutoAddPolicy())

# sudo iptables -L INPUT --line-numbers --numeric

for hostx in all_hosts:
    try:
        c.connect( hostname = hostx, username = "ksatyamurthy", pkey = k, timeout=20)
        stdin , stdout, stderr = c.exec_command(ip_tables_rules)
        cmd_output1=stdout.read().decode()
        return_code1=stdout.channel.recv_exit_status()
        err_output1=stderr.read().decode()
        stdin.close()
        if(int(return_code1) == 0 and int(cmd_output1) == 0):
            print(f"{hostx} is OK")
            print(f"\t Enable logging...")
            # print(err_output1)
            stdin , stdout, stderr = c.exec_command(ip_tables_logging_port)
            cmd_output2=stdout.read().decode()
            return_code=stdout.channel.recv_exit_status()
            stdin.close()
            if(len(cmd_output2.split('\n')[:-1]) == 0):
                print(f"\t no process")
            for x in cmd_output2.split('\n')[:-1]:
                print(f"\t {x}")
        elif(int(cmd_output1) > 0):
            print(f"{hostx}: iptables rules exists already")
        elif(int(return_code1) != 0):
            print(f"{hostx}: {err_output1}")
        c.close()
    except Exception as e:
        print(f"{hostx}: {e}")


