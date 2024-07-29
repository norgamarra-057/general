#!/usr/bin/env bash

# Load generic functions
source "$(dirname $0)/globals.sh"

HOSTGROUPS=$(get_mysql_clusters)

echo "Checking replication on host groups:"
print_mysql_clusters "${HOSTGROUPS}"

# Run check
ansible-playbook plays/tests/check_mysql_mha_replication.yml --limit "${HOSTGROUPS}"
