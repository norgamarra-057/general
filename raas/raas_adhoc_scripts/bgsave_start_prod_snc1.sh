for i in `/opt/redislabs/bin/rladmin status shards  | egrep '^db:69 ' | grep slave | awk '{ print $3 }' | sed -e 's/redis://'`
do
echo "shard-cli $i BGSAVE"
/opt/redislabs/bin/shard-cli $i BGSAVE
echo "$i"
echo "Bgcopy started"
sleep 25
done
