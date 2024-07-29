#!/usr/bin/env bash

# Load generic functions
source "$(dirname $0)/globals.sh"

HOSTGROUPS=$(get_mysql_clusters)

echo "Updating VIP configuration on host groups:"
print_mysql_clusters "${HOSTGROUPS}"

# Run check
ansible-playbook plays/freebsd/vips.yml --limit "${HOSTGROUPS}"
