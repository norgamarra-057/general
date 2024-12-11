#!/bin/bash
echo -e "\n##################################\n Long running top 5 queries\n##################################"

psql -h $1 -U postgres -c "select now()-query_start as duration,left(query,500) as query,state,wait_event,wait_event_type from pg_stat_activity where state<>'idle' and query not like 'select now()-query_start%' AND query not like 'START_REPLICATION%'  order by 1 desc limit 5;"

echo -e "\n##################################\n Active User connection count\n##################################"
psql -h $1 -U postgres -c "select usename,state,count(1) from pg_stat_activity where state<>'idle' group by 1,2;"

echo -e "\n##################################\n Total connection count\n##################################"
psql -h $1 -U postgres -c "select state,count(1) from pg_stat_activity group by 1;"

echo -e "\n##################################\n Replication Lag\n##################################"
psql -h $1 -U postgres -c "SELECT pg_stat_replication.client_addr AS slave_ip,
round(pg_wal_lsn_diff(pg_current_wal_lsn(), pg_stat_replication.replay_lsn) / 1048576::numeric) AS result
FROM pg_stat_replication
WHERE pg_stat_replication.application_name = 'walreceiver'::text;"

echo -e "\n##################################\n Blocked queries \n##################################"

psql -h $1 -U postgres -c "SELECT blocked_locks.pid AS blocked_pid,
blocked_activity.usename AS blocked_user,
blocking_locks.pid AS blocking_pid,
blocking_activity.usename AS blocking_user,
blocked_activity.query AS blocked_statement,
blocking_activity.query AS current_statement_in_blocking_process
FROM pg_locks blocked_locks
JOIN pg_stat_activity blocked_activity ON blocked_activity.pid = blocked_locks.pid
JOIN pg_locks blocking_locks ON blocking_locks.locktype = blocked_locks.locktype AND NOT blocking_locks.database IS DISTINCT FROM blocked_locks.database AND NOT blocking_locks.relation IS DISTINCT FROM blocked_locks.relation AND NOT blocking_locks.page IS DISTINCT FROM blocked_locks.page AND NOT blocking_locks.tuple IS DISTINCT FROM blocked_locks.tuple AND NOT blocking_locks.virtualxid IS DISTINCT FROM blocked_locks.virtualxid AND NOT blocking_locks.transactionid IS DISTINCT FROM blocked_locks.transactionid AND NOT blocking_locks.classid IS DISTINCT FROM blocked_locks.classid AND NOT blocking_locks.objid IS DISTINCT FROM blocked_locks.objid AND NOT blocking_locks.objsubid IS DISTINCT FROM blocked_locks.objsubid AND blocking_locks.pid <> blocked_locks.pid
JOIN pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted AND blocking_locks.granted IS TRUE ;"
