#!/usr/bin/env bash

# Set list of instances
if [ $# -gt 0 ]; then
  INSTANCES=""
  for INSTANCE in $@; do
    if [ -f /root/.my.cnf-${INSTANCE} ]; then
      INSTANCES="${INSTANCES} ${INSTANCE}"
    else
      echo " [!] instance not found: ${INSTANCE}"
      exit 2
    fi
  done
else
  INSTANCES=$(list_instances | awk '{print $NF}')
fi

SUMSTATUS=0
for INSTANCE in ${INSTANCES}; do
  SOCKET="/var/groupon/percona/${INSTANCE}/mysql.sock"

  # Get slave status
  SLAVE_STATUS=$(mysql -S ${SOCKET} -e "SHOW SLAVE STATUS\G" 2>&1)
  if [ $? -ne 0 ]; then
    echo " [!] ${INSTANCE}: error getting slave status"
    echo "${SLAVE_STATUS}"
    ((SUMSTATUS++))
    continue
  fi

  # Check slave IO status
  SLAVE_IO_RUNNING=$(echo "${SLAVE_STATUS}" | grep 'Slave_IO_Running:' | awk '{ print $2 }')
  if [ -z "${SLAVE_IO_RUNNING}" ]; then
    echo " [*] ${INSTANCE}: not a slave, skipping"
    continue
  elif [ "${SLAVE_IO_RUNNING}" != "Yes" ]; then
    echo " [!] ${INSTANCE}: slave IO not running"
    SLAVE_LAST_IO_ERROR=$(echo "${SLAVE_STATUS}" | grep 'Last_IO_Error:' | cut -d':' -f 2-)
    echo "${SLAVE_LAST_IO_ERROR}"
    ((SUMSTATUS++))
    continue
  fi

  # Check slave SQL status
  SLAVE_SQL_RUNNING=$(echo "${SLAVE_STATUS}" | grep 'Slave_SQL_Running:' | awk '{ print $2 }')
  if [ "${SLAVE_SQL_RUNNING}" != "Yes" ]; then
    echo " [!] ${INSTANCE}: slave SQL not running"
    SLAVE_LAST_SQL_ERROR=$(echo "${SLAVE_STATUS}" | grep 'Last_SQL_Error:' | cut -d':' -f 2-)
    echo "${SLAVE_LAST_SQL_ERROR}"
    ((SUMSTATUS++))
    continue
  fi

  # Check slave lag
  SLAVE_SECONDS_BEHIND=$(echo "${SLAVE_STATUS}" | grep 'Seconds_Behind_Master:' | awk '{ print $2 }')

  # Got here, everything should be OK
  echo " [*] ${INSTANCE}: OK (IO: ${SLAVE_IO_RUNNING}, SQL: ${SLAVE_SQL_RUNNING}, perceived lag: ${SLAVE_SECONDS_BEHIND})"
done

exit $SUMSTATUS
