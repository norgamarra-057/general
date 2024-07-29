#!/usr/bin/env bash
#
# resolve vip's to hosts with db names
#
#  usage:
#   unvipme gds-snc1-stage-po-manager-rw-vip.snc1

#REPODIR='/home/asutherland/repos/paver'

IP=`host $1 | grep 'has address' | cut -f 4 -d " "`

if [ $IP = 'found' ]
then
	echo "error could not resolve that VIP, yo"
	echo
	exit
fi

# show the IP for the VIP
echo "IP is $IP"

#cd $REPODIR

# show the file that contains the config
FILE=`git grep "$IP\>" | grep 'inventory/group_vars/' | awk '{print $1}' | cut -f 1 -d ":"`
echo "$FILE"

# show the name of the instance
INSTANCE=`grep -I35 $IP $FILE | egrep "^  [a-z]" | tail -n1 | cut -f 1 -d ":" | awk '{print $1}'`
echo "$INSTANCE"

# show the hosts in the cluster
grep -A20 $INSTANCE $FILE | egrep -A5 "nodes:" | egrep "^      - " | sort | uniq

