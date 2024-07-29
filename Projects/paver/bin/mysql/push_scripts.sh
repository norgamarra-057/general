#!/usr/bin/env bash

# Load generic functions
source "$(dirname $0)/globals.sh"

[ -n "$1" ] && PATTERN="$1" || PATTERN=""

HOSTGROUPS=$(get_mysql_clusters ${PATTERN})

# Execute play
for HOSTGROUP in $(list_mysql_clusters ${HOSTGROUPS}); do
  echo " [*] pushing to ${HOSTGROUP}"
  ansible-playbook plays/envs/${HOSTGROUP}.yml --tags mysql-scripts
done
