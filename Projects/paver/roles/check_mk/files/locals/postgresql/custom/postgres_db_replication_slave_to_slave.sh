#!/usr/local/bin/bash
#   __ _  __
#  (_ / \/
#  __)\_/\__
#
# nagios plugin wrapper for cached local checks.
# MON-584 - sblaurock - 2014-02-14 - V1.0
MK_CONFDIR=/etc/check_mk

# Ports to check
for postgresinstance in $(grep -e '\[.*\]' $MK_CONFDIR/postgres.cfg | sed -e 's/\[//g' -e 's/\]//g' | tr '\n' ' ');do
currentinstance=$(grep -A3 "${postgresinstance}" $MK_CONFDIR/postgres.cfg | head -n 4)
Port=$(echo "$currentinstance" | grep "port=" | sed -e 's/port=//')
vip=$(echo "$currentinstance" | grep "vip=" | sed -e 's/vip=//')
dbname=$(echo "$currentinstance" | grep "dbname=" | sed -e 's/dbname=//')
name=$(echo $postgresinstance)


# extract service description from filename
ServiceDescription="PostgreSQL_Port:_${Port}_${dbname}_-_Repl_Delay_Slave_to_Slave"

# fetch results and catch the exit status
Output=$(/var/groupon/check_mk/checks/check_db_replication_delay_slave_to_slave -w 100000000 -c 1000000000 -p $Port)
ExitCode=$?

# Ab hier nicht mehr editieren!
echo "$ExitCode $ServiceDescription $Output"
sleep 0.5
done
