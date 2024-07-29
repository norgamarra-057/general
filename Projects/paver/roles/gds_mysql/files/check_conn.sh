#!/usr/bin/env bash

INSTANCES="$@"
[ -z "${INSTANCES}" ] && INSTANCES=$(list_instances | awk '{print $NF}')

# Checks connections on mutli-instance GDS hosts
for instance in ${INSTANCES}; do
    echo "***${instance}***"
    mi.sh -s "$instance"
    echo "select * from information_schema.processlist where user not in ('root', 'system user', 'pt_heartbeat')" | mysql
    echo 
done
