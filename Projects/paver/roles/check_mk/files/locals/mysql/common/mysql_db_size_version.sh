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

ServiceDescription="MySQL_db_version_and_size_${name}"
Output=$(mysql -u ${user} -P ${port} --${socket} -e 'SHOW VARIABLES LIKE "%version%";' -s -N)
ExitCode=$?
Output2=$(mysql -u ${user} -P ${port} --${socket} -e 'SELECT table_schema "DB Name", Round(Sum(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB" FROM   information_schema.tables GROUP  BY table_schema; ' -s -N)


echo "$ExitCode $ServiceDescription $Output"
echo "$ExitCode $ServiceDescription $Output2"
sleep 0.5
done