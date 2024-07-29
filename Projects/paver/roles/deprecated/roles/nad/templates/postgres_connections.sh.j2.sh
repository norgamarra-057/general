#!/bin/sh --


QUERY="select count(*) from pg_stat_activity where pid != pg_backend_pid();"
ANSWER=`psql -U circonus_mon -t -p 20065 ihq_uat -c "$QUERY"`

echo 'postgresql`connections' $ANSWER