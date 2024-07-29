#!/usr/bin/env bash

# Minimal script to quickly check HA status across the board (rb)

MHAUSER=gds_mha
GLOBALRET=0

# Quiet mode check
[ -n "$1" -a "$1" == "-q" ] && QUIET=1 || QUIET=0

if [ "`whoami`" != "${MHAUSER}" ]; then
  echo "this script must be run as ${MHAUSER}"
  exit 100
fi

# Check all the instances
for c in ${HOME}/*.cnf; do
  INSTANCE=${c%%-mha.cnf}
  NAME=${INSTANCE##*/}
  OUTPUT=`masterha_check_repl --conf $c 2>&1`
  RETCODE=$?
  STATUS=`echo "$OUTPUT" | tail -1`
  if [ "${RETCODE}" -gt 0 ]; then
    HASEXTERNAL=$(echo "${OUTPUT}" | grep 'is not defined in the configuration file!' | wc -l)
    if [ ${HASEXTERNAL} -gt 0 ]; then 
      printf " [o] %-26s %s\n" "${NAME}" "not monitored (has external replication)"
      continue
    else
      printf " [!] %-26s %s\n" "${NAME}" "${STATUS}"
    fi
    echo "${OUTPUT}" | grep -- "\[error\]"
  elif [ "${QUIET}" == 0 ]; then
    printf " [*] %-26s %s\n" "${NAME}" "${STATUS}"
  fi
  ((GLOBALRET+=RETCODE))
done

# Returns more than 0 if there was an error
exit ${GLOBALRET}
