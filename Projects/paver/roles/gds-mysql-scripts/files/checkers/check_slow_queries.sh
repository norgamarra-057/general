#!/usr/bin/env bash

# Save instance pointer
current_instance=$(current_instance)

TIMELIMIT=1000
NQUERY=5
EXCLUDE_LIST="'system user','pt_heartbeat','root','repl', 'replication'"

while getopts "t:n:" opt; do
  case $opt in
    t) TIMELIMIT=${OPTARG} ;;
    n) NQUERY=${OPTARG} ;;
  esac
done

# Checks connections on mutli-instance GDS hosts
read -r -d '' VAR << 'SQL'
SELECT * FROM information_schema.processlist
WHERE user not in (${EXCLUDE_LIST})
  AND TIME > ${TIMELIMIT}
  AND COMMAND <> 'Sleep'
SQL

for instance in $(list_instances | awk '{ print $NF }'); do
    echo " [*] ${instance}"
    select_instance "$instance"
    mysql -e "${SQL}" | head -n ${NQUERY}
done

# Restore instance pointer
select_instance ${current_instance}
