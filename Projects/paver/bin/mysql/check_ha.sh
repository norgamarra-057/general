#!/usr/bin/env bash

# Checks HA status in the environment

# Load generic functions
source "$(dirname $0)/globals.sh"

HOSTGROUPS=$(get_mysql_clusters)

echo "Checking HA status on host groups:"
for HOSTGROUP in $(list_mysql_clusters ${HOSTGROUPS}); do
    M=$(echo "${HOSTGROUP}m1" | tr '_' '-')
    S=$(echo "${HOSTGROUP}s1" | tr '_' '-')
    echo "--- ${HOSTGROUP} ---"
    INSTANCES=$(ssh ${SSH_OPTIONS} ${M} sudo /usr/local/sbin/list_instances 2>/dev/null | awk '{print $NF}')
    for INSTANCE in ${INSTANCES}; do
      m_status=$(ssh ${SSH_OPTIONS} ${M} sudo /usr/local/sbin/check_repl.sh ${INSTANCE} | grep 'not a slave' | wc -l)
      s_status=$(ssh ${SSH_OPTIONS} ${S} sudo /usr/local/sbin/check_repl.sh ${INSTANCE} | grep 'not a slave' | wc -l)
      if [ $m_status -gt 0 -a $s_status -gt 0 ]; then
        printf " [!] %-26s FAIL\n" ${INSTANCE}
      else
        printf " [*] %-26s OK\n" ${INSTANCE}
      fi
    done
done
