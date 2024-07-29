#!/usr/bin/env bash

# Load generic functions
source "$(dirname $0)/globals.sh"

HOSTGROUPS=$(get_mysql_clusters)

echo "Searching for dead instances on host groups:"
print_mysql_clusters "${HOSTGROUPS}"

# Execute play
ansible-playbook plays/tests/find_dead_mysql_instances.yml --limit "${HOSTGROUPS}"
