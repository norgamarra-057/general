#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

USAGE="usage: $0 <GPROD> <PORT> <SLAVEOF_HOST> <SLAVEOF_PORT>"
GPROD=$1
PORT=$2
SLAVEOF_HOST=$3
SLAVEOF_PORT=$4

[ -z $GPROD ] && echo $USAGE && exit 1
[ -z $PORT ] && echo $USAGE && exit 1
[ -z $SLAVEOF_HOST ] && echo $USAGE && exit 1
[ -z $SLAVEOF_PORT ] && echo $USAGE && exit 1

LOGFILE=/var/groupon/log/redis.$PORT.log
PIDFILE=/var/run/redis.$PORT.pid

[ -f $PIDFILE ] && echo 'PORT already used! You may want to run:' && echo "sudo pkill -F $PIDFILE" && exit 2

# empty logfile and write GPROD info on the first line
echo "GPROD: $GPROD" > $LOGFILE

/usr/local/bin/redis-server --dir /var/groupon/ --save "" --appendonly no --daemonize yes --port $PORT --slaveof $SLAVEOF_HOST $SLAVEOF_PORT --logfile $LOGFILE --pidfile $PIDFILE
echo "Success!"
echo "LOGFILE: $LOGFILE"
echo "PIDFILE: $PIDFILE"
