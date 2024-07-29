#!/usr/bin/env bash

# Load generic functions
source "$(dirname $0)/globals.sh"

[ -n "$1" ] && PATTERN="$1" || PATTERN=""

HOSTGROUPS=$(get_mysql_clusters ${PATTERN})

echo "Checking mysql state on host groups:"
print_mysql_clusters "${HOSTGROUPS}"

# Run check
ansible-playbook plays/tests/check_mysql_state.yml --limit "${HOSTGROUPS}"
