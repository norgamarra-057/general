#!/usr/bin/env bash

# Save instance pointer
current_instance=$(current_instance)

# Checks connections on mutli-instance GDS hosts
for instance in `list_instances | awk '{ print $NF; }'`; do
    echo "***${instance}***"
    select_instance "$instance"
    echo "select * from information_schema.processlist where user not in ('root', 'system user', 'pt_heartbeat')" | mysql
    echo
done

# Reset instance
select_instance ${current_instance}
