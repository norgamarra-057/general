#!/bin/bash 
# strict 
# set -euo pipefail

display_usage() { 
    echo -e "\nUsage: missing 4 arguments \n $0 source-db-name redislabs-endpoint target-hostname target-port \n" 
} 

if [  $# -le 1 ] 
then 
    display_usage
    exit 1
fi 


# source_dbname="tpis-staging"
# source_endpoint="redis-12350.snc1.raas-shared1-staging.grpn"
# target_endpoint="raas-pool10.snc1"
# target_port="6379"


source_dbname="$1"
source_endpoint="$2"
target_endpoint="$3"
target_port="$4"


cluster_name=`echo "$source_endpoint" | sed -e 's/redis-[0-9][0-9]*.//g'`
source_port=`echo "$source_endpoint" | awk -F. '{ print $1 }' | awk -F- '{ print $2 }' `



cat > _tmp.sh <<EOL

# strict 
# set -euo pipefail

source_dbname="$source_dbname"
source_endpoint="$source_endpoint"
target_endpoint="$target_endpoint"
target_port="$target_port"

cluster_name=\`echo "\$source_endpoint" | sed -e 's/redis-[0-9][0-9]*.//g'\`
source_port=\`echo "\$source_endpoint" | awk -F. '{ print \$1 }' | awk -F- '{ print \$2 }' \`


bigdir=/var/groupon/$(whoami)
sudo mkdir -p \$bigdir
sudo chown \$(whoami): \$bigdir
cd \$bigdir

monitor_this_file()
{
var1=\`sudo lsof | grep -c \$1\`
until [ \$var1 -eq 0 ]; do 
    sleep 5; 
    var1=\`sudo lsof | grep -c \$1\`; 
done
}


type_cluster=\`sudo redis-cli -h \$target_endpoint -p \$target_port info cluster | sed "1d" | tr -d '\r' \`

if [[ \$type_cluster == "cluster_enabled:0" ]]; then

    echo
    echo "BEFORE:"
    echo "Source:"
    sudo redis-cli -h \$source_endpoint -p \$source_port info keyspace 
    echo 
    echo "Target:"
    sudo redis-cli -h \$target_endpoint -p \$target_port info keyspace 
    echo 
    echo "Type: ok to proceed."
    read ok1

    if [[ \$ok1 == "ok" ]]; then

        echo
        echo "Running..."
        sudo rladmin status shards db \$source_dbname > shards.txt
        cat shards.txt | grep slave | awk '{print \$3}' | awk -F: '{print \$2}' > shard_no.txt 

        for xshard in \`cat shard_no.txt\`
        do
            sudo shard-cli \$xshard --rdb shard-\${xshard}.rdb 
            sleep 5
            #monitor_this_file shard-\${xshard}.rdb
            # var1=\`sudo lsof | grep -c shard-\${xshard}.rdb \`
            # echo \$var1
            # while ![ \$var1 -eq 0 ]; 
            # do 
            #     sleep 5; 
            #     echo "inside loop"
            #     var1=\`sudo lsof | grep -c shard-\${xshard}.rdb \`;
            # done
            sudo rl_rdbloader shard-\${xshard}.rdb --action load --addr \$target_endpoint --port \$target_port
            sudo rm -vf shard-\${xshard}.rdb 
        done

        echo 
        echo "AFTER:"
        echo "Source:"
        sudo redis-cli -h \$source_endpoint -p \$source_port info keyspace 
        echo 
        echo "Target:"
        sudo redis-cli -h \$target_endpoint -p \$target_port info keyspace 
        echo 

    else 
        exit 0
    fi

fi



if [[ \$type_cluster == "cluster_enabled:1" ]]; then

    echo
    echo "BEFORE:"
    echo "Source:"
    sudo redis-cli -h \$source_endpoint -p \$source_port info keyspace 
    echo 
    echo "Target:"
    #sudo redis-cli --cluster call \$target_endpoint:\$target_port info keyspace | egrep -o 'keys=[0-9]+,' | tr -d ',=keys' | awk '{sum+=\$NF} END {print sum}'
    echo 
    echo ""
    echo "Type: ok to proceed."
    read ok1

    if [[ \$ok1 == "ok" ]]; then
        sudo rladmin status shards db \$source_dbname > shards.txt
        cat shards.txt | grep slave | awk '{print \$3}' | awk -F: '{print "sudo shard-cli "\$2" --rdb shard."\$2".rdb; sleep 10;"}' | bash -vx
         
        NODES=\$(sudo redis-cli -h \$target_endpoint -p \$target_port cluster nodes | grep master | cut -f2 -d' ' | cut -f1 -d@)
        for rdb in \$(ls shard.*.rdb); do
          for node in \$NODES; do
            echo \$(date) rdb=\$rdb node=\$node
            h=\${node%:*}
            p=\${node#*:}
            sudo rl_rdbloader \$rdb --action load --addr \$h --port \$p >/dev/null 2>&1
          done
          rm -vf \$rdb
        done

        echo 
        echo "AFTER:"
        echo "Source:"
        sudo redis-cli -h \$source_endpoint -p \$source_port info keyspace 
        echo 
        echo "Target:"
        sudo redis-cli --cluster call \$target_endpoint:\$target_port info keyspace | egrep -o 'keys=[0-9]+,' | tr -d ',=keys' | awk '{sum+=\$NF} END {print sum}'
        echo 
         
    else
        exit 0
    fi

fi


EOL


#scp _tmp.sh raas-shared-huge1-us.snc1:
scp _tmp.sh $cluster_name:

ssh $cluster_name "bash _tmp.sh"
#ssh raas-shared-huge1-us.snc1 "bash _tmp.sh"

rm -vf _tmp.sh


