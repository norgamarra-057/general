#!/bin/sh --

#Definition of variable
#MAXTIME=14400 #4h
MAXTIME=86400 #24h
THRESHOLD=2
##futuring proofing this
BACKUP_USER=backup #backup system need to be changed before this take effect
#JOBS=$(ps axo etimes,command -U $BACKUP_USER| grep '[/]sh -- /var/groupon/delorean' | sort -n | tr -s ' ' | \
#cut -d ' ' -f2 | awk -v MAXTIME=$MAXTIME -v THRESHOLD=$THRESHOLD '{ if ($1>=MAXTIME) count++ } \
#END { print count}')


JOBS=$(ps axo etimes,command | grep '[/]sh -- /var/groupon/delorean' | sort -n | tr -s ' ' | \
cut -d ' ' -f2 | awk -v MAXTIME=$MAXTIME '{ if ($1>=MAXTIME) count++ } \
END { print count}')

#active in case we have a local check
CODE=255
case $JOBS in
0)
	CODE=0
	echo "OLDJOB OK - $JOBS unfinished task"
	exit 0
;;
[1-$THRESHOLD])
	CODE=1
	echo "OLDJOB WARNING - $JOBS unfinished task"
	exit 1
;;
*)
	CODE=2
	echo "OLDJOB CRITICAL - $JOBS unfinished task"
	exit 2
;;
esac
#passive to push through nsca
#echo -e "$(hostname)\tstalled_backup_job\t${CODE}\t${JOBS}" | /usr/sbin/send_nsca
