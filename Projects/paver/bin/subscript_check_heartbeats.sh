#!/usr/bin/env bash

for i in `list_instances | sed "s/\*//g"`; 
do 
select_instance $i; 
echo -ne "$i :  "; 
mysql -e "select count(*), @@server_id from percona.heartbeat;"; 
mysql -e "select ts, server_id from percona.heartbeat;"; 
echo "" ;
 done