for i in `/opt/redislabs/bin/rladmin status shards  | egrep 'dealservice-shield' | grep slave | awk '{ print $3 }' | sed -e 's/redis://'`
do
echo "shard-cli $i BGSAVE"
/opt/redislabs/bin/shard-cli $i BGSAVE  > bgsave.log
var=`cat bgsave.log | grep -c "ERR"`
if [[ $var -eq 0 ]]; then 
  echo "$i"
  echo "Bgcopy started"
  sleep 15
else
  sleep 30
  /opt/redislabs/bin/shard-cli $i BGSAVE
  sleep 15
fi
rm -f bgsave.log
done
