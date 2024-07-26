# dub1.raas-dealcatalog-prod.grpn
#       raas-deal-catalog1.dub1
#       raas-deal-catalog[1-6].dub1

# snc1.raas-shared3-staging.grpn
#       raas-shared-huge1-staging.snc1
#       raas-shared-huge[1-5]-staging.snc1

# COLO="snc1"
# ENVMNT="staging"
# CLSNME="snc1.raas-shared3-staging.grpn"
# HSTNME="raas-shared-huge[1-5]-staging.snc1"

# COLO="dub1"
# ENVMNT="prod"
# CLSNME="dub1.raas-shared3-prod.grpn"
# HSTNME="raas-shared-huge[1-4].dub1"
# 
# COLO="dub1"
# ENVMNT="prod"
# CLSNME="dub1.raas-dealcatalog-prod.grpn"
# HSTNME="raas-deal-catalog[1-6].dub1"

# COLO="snc1"
# ENVMNT="prod"
# CLSNME="snc1.raas-shared3-prod.grpn"
# HSTNME="raas-shared-huge[1-5].snc1"
# 
# COLO="snc1"
# ENVMNT="prod"
# CLSNME="snc1.raas-dealcatalog-prod.grpn"
# HSTNME="raas-deal-catalog[1-6].snc1"


COLO="sac1"
ENVMNT="prod"
CLSNME="sac1.raas-shared3-prod.grpn"
HSTNME="raas-shared-huge[1-5].sac1"

COLO="sac1"
ENVMNT="prod"
CLSNME="sac1.raas-dealcatalog-prod.grpn"
HSTNME="raas-deal-catalog[1-3].sac1"

# pdsh -w $HSTNME "hostname -f;sudo ls -l /var/groupon/redislabs/ephemeral/redis-*.rdb"
# pdsh -w $HSTNME "hostname -f;sudo rm -vf /var/groupon/redislabs/ephemeral/redis-*.rdb"

# 🔺 change the db:14 snc1, db:2 prod & then db:69
# 🔺 change the db:14 staging, db:1 prod & then db:59
# 🔺 change the  db:1 prod

ssh $CLSNME "curl -sk https://raw.github.groupondev.com/data/raas/master/raas_adhoc_scripts/bgsave_start_${ENVMNT}_${COLO}.sh | sudo bash -vx"

#for i in `sudo rladmin status shards  | egrep '^db:1' | grep slave | awk '{ print $3 }' | sed -e 's/redis://'`
#do
#echo "sudo shard-cli $i BGSAVE"
#sudo shard-cli $i BGSAVE
#echo "$i"
#echo "Bgcopy started"
#done

sleep 1m;

# Wait until all bgsave completes
while(pdsh -f1 -w $HSTNME "ls /var/groupon/redislabs/ephemeral/*.rdb 2>/dev/null" 2>/dev/null | grep -q "temp-.*.rdb" );do echo "wait";sleep 1; done

# 10 bells
for i in `seq 10`; do tput bel ; sleep 1 ; done

pdsh -f1 -w $HSTNME "hostname -f;sudo ls -l /var/groupon/redislabs/ephemeral/redis-*.rdb"
# move the files

pdsh -w $HSTNME "sudo mkdir -p /var/groupon/raas/; sudo mv /var/groupon/redislabs/ephemeral/redis-*.rdb /var/groupon/raas/"
pdsh -w $HSTNME "sudo ls -l /var/groupon/raas/redis-*.rdb" | cat -n 


pdsh -f1 -w $HSTNME "curl -sk https://raw.github.groupondev.com/data/raas/master/raas_adhoc_scripts/start_webserver_12222.sh | sudo bash -vx"




pdsh -f1 -w $HSTNME "ls /var/groupon/raas/redis-*.rdb"


pdsh -f1 -w $HSTNME "ls /var/groupon/raas/redis-*.rdb  2>/dev/null" | sed -e "s/: /.${COLO}:12222/" -e 's~^~http://~' -e 's~/var/groupon/raas/~/~'


# http://raas-shared-huge1-staging.snc1:12222/redis-75.rdb
# http://raas-shared-huge2-staging.snc1:12222/redis-77.rdb
# http://raas-shared-huge2-staging.snc1:12222/redis-82.rdb
# http://raas-shared-huge3-staging.snc1:12222/redis-78.rdb
# http://raas-shared-huge4-staging.snc1:12222/redis-501.rdb
# http://raas-shared-huge4-staging.snc1:12222/redis-505.rdb
# http://raas-shared-huge4-staging.snc1:12222/redis-79.rdb
# http://raas-shared-huge5-staging.snc1:12222/redis-81.rdb


pdsh -f1 -w $HSTNME "cat /var/groupon/raas/webserver_p12222.log"
pdsh -f1 -w $HSTNME  "sudo pkill -f p12222 && echo 'process p12222 killed'"
pdsh -f1 -w $HSTNME "sudo rm -vf /var/groupon/raas/webserver_p12222.log"
pdsh -f1 -w $HSTNME "sudo rm -vf /var/groupon/raas/redis-*.rdb"

