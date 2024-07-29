#!/usr/bin/env bash
#set -e

if [ -n "$1" ]; then
    REMOTE="$1"
else
    echo "Usage: $0 new_master"
    exit 1
fi

# Test remote conn
STATUS=$(ping -c 1 $REMOTE 2>&1)
if [ $? -ne 0 ]; then
    echo "Remote host ${REMOTE} not available:"
    echo "$STATUS"
    exit 2
fi

for c in *.cnf; do
    INSTANCE=${c%%-mha.cnf}
    echo "***Failing over ${INSTANCE}***"
    masterha_master_switch --conf=$c \
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
done
