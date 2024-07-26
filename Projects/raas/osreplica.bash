#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

USAGE="usage: $0 <TICKET> <PORT> <SLAVEOF_HOST> <SLAVEOF_PORT> <PASSWORD>"
TICKET=$1
PORT=$2
SLAVEOF_HOST=$3
SLAVEOF_PORT=$4
PASSWORD=$5

[ -z $TICKET ] && echo $USAGE && exit 1
[ -z $PORT ] && echo $USAGE && exit 1
[ -z $SLAVEOF_HOST ] && echo $USAGE && exit 1
[ -z $SLAVEOF_PORT ] && echo $USAGE && exit 1
[ -z $PASSWORD ] && echo $USAGE && exit 1

LOGFILE=/var/groupon/log/redis.$PORT.log
PIDFILE=/var/run/redis.$PORT.pid

[ -f $PIDFILE ] && echo 'pidfile found! You may want to run:' && echo "sudo pkill -F $PIDFILE" && exit 2

/usr/local/bin/redis-cli -p $PORT ping > /dev/null 2>&1
[ $? -eq 0 ] && echo 'PORT already used! You may want to run:' && echo "sudo pkill -F $PIDFILE" && exit 3

[ -f /var/groupon/dump.rdb ] && echo 'snapshot file found! You may want to run:' && echo "sudo rm /var/groupon/dump.rdb" && exit 4

# empty logfile and write TICKET info on the first line
echo "TICKET: $TICKET" > $LOGFILE

/usr/local/bin/redis-server --dir /var/groupon/ --save '' --appendonly no --daemonize yes --port $PORT --logfile $LOGFILE --pidfile $PIDFILE
until /usr/local/bin/redis-cli -p $PORT ping > /dev/null 2>&1
sleep 3
do
  echo "Waiting for server to start"
  sleep 3
done
echo "Setting replication"
/usr/local/bin/redis-cli -p $PORT CONFIG SET protected-mode no
/usr/local/bin/redis-cli -p $PORT CONFIG SET masterauth $PASSWORD
/usr/local/bin/redis-cli -p $PORT REPLICAOF $SLAVEOF_HOST $SLAVEOF_PORT
echo "LOGFILE: $LOGFILE"
echo "PIDFILE: $PIDFILE"
