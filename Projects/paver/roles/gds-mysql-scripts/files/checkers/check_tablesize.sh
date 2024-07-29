#!/usr/bin/env bash

# Check tablesizes on a single-instance of a GDS host

# Run against the instance name, if provideded. 
# If none provided, run against the current instance

if [ "$#" -gt 0 ]; then
	instance=$1
else
	instance=`current_instance`
fi

echo
echo "Instance: $instance" 
echo
echo "select round(sum((data_length+index_length)/1024/1024/1024),4) as GB, table_name as Table_Name from information_schema.tables where table_schema not in ('information_schema','hydra','mysql','percona','performance_schema','sys') and table_type not in ('VIEW') group by table_name order by 1 desc" | mysql -S /var/groupon/percona/${instance}/mysql.sock
echo
