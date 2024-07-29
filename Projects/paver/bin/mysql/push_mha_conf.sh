#!/usr/bin/env bash

# Load generic functions
source "$(dirname $0)/globals.sh"

HOSTGROUPS=$(get_mysql_clusters)

# Execute play
for HOSTGROUP in $(list_mysql_clusters ${HOSTGROUPS}); do
  echo " [*] pushing to ${HOSTGROUP}"
  ansible-playbook plays/envs/${HOSTGROUP}.yml --tags mha-instance
done
