#!/usr/local/bin/bash
#   __ _  __
#  (_ / \/
#  __)\_/\__
#
# nagios plugin wrapper for cached local checks.
# MON-584 - sblaurock - 2014-02-14 - V1.0
MK_CONFDIR=/etc/check_mk

for mysqlinstance in $(grep -e '\[.*\]' $MK_CONFDIR/mysql.cfg | sed -e 's/\[//g' -e 's/\]//g' | tr '\n' ' ');do
currentinstance=$(grep -A2 "${mysqlinstance}" $MK_CONFDIR/mysql.cfg)
port=$(echo "$currentinstance" | grep "port=" | sed -e 's/port=//')
user=root
socket=$(echo "$currentinstance" | grep "socket=")
name=$(echo $mysqlinstance)

ServiceDescription="MySQL_Replication_Delay_${name}"
Output=$(/var/groupon/check_mk/checks/check_db_replication_delay_mysql -u ${user} -p ${port} -s ${socket} -w 60 -c 120)
ExitCode=$?

echo "$ExitCode $ServiceDescription $Output"
sleep 0.5
done
