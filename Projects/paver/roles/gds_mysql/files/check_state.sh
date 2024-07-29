#!/usr/bin/env bash

# Checks connections on mutli-instance GDS hosts
for instance in `mi.sh -l | awk '{ print $NF; }'`; do
    echo -n "${instance}: "
    mi.sh -s "$instance"
    STATE=$(echo "select @@read_only;" | mysql --silent --silent)
    [ "${STATE}" -eq 1 ] && echo "read-only" || echo "read-write"
done
