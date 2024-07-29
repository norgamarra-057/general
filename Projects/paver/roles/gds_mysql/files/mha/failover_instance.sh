#!/usr/bin/env bash
#set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 new_master instance"
    exit 1
else
    REMOTE="$1"
    INSTANCE="$2"
fi

# Test remote conn
STATUS=$(ping -c 1 $REMOTE 2>&1)
if [ $? -ne 0 ]; then
    echo "Remote host ${REMOTE} not available:"
    echo "$STATUS"
    exit 2
fi

# Check instance config
if [ -f "${INSTANCE}" ]; then
    CONF="${INSTANCE}"
else
    CONF="${INSTANCE}-mha.cnf"
fi

if [ ! -f "${CONF}" ]; then
    echo "Could not find configuration for ${INSTANCE}"
    exit 3
fi

echo "***Failing over ${INSTANCE}***"
masterha_master_switch --conf=$CONF \
    --master_state=alive \
    --new_master_host=$REMOTE \
    --orig_master_is_new_slave \
    --interactive=0
RETCODE=$?
if [ $RETCODE -ne 0 ]; then
    echo "Error failing over ${INSTANCE}"
    exit $RETCODE
else
    echo "Failover of ${INSTANCE} completed."
fi
echo
