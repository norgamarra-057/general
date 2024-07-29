#!/bin/sh --

QUERY="select case when ((select count(*) from pg_stat_replication) >0) then (select pg_xlog_location_diff(write_location, replay_location) as result from pg_catalog.pg_stat_replication where application_name = 'walreceiver' order by 1 desc limit 1) else 1500000000 end ;"

ANSWER=`psql -U circonus_mon -t -p 20065 ihq_uat -c "$QUERY"`

echo 'postgresql`lag_replication' $ANSWER