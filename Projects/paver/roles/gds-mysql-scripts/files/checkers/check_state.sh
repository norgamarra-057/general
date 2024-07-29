#!/usr/bin/env bash

current_instance=$(current_instance)

CHECK_VIPS=0
VIPSTATUS=""
VERBOSE=1
if [ -n "$1" -a "$1" == '-v' ]; then
  CHECK_VIPS=1
  VIPSTATUS="$(check_vips.sh 2>&1)"
elif [ -n "$1" -a "$1" == '-e' ]; then
  CHECK_VIPS=1
  VIPSTATUS="$(check_vips.sh 2>&1)"
  VERBOSE=0
fi

# Checks connections on mutli-instance GDS hosts
retcode=0
for instance in `list_instances | awk '{ print $NF; }'`; do
    select_instance "$instance"
    STATE=$(echo "select @@read_only;" | mysql --silent --silent 2>&1)
    if [ $? -ne 0 ]; then
      echo "${instance}: could not obtain status"
      echo "   [!] ${STATE}"
      (( retcode++ ))
      continue
    fi
    IS_SLAVE=$(echo "show slave status;" | mysql --silent --silent | wc -l)
    if [ "${VERBOSE}" -eq 1 ]; then
      echo -n "${instance}: "
      [ "${STATE}" -eq 1 ] && echo "read-only" || echo "read-write"
    fi
    if [ ${CHECK_VIPS} -gt 0 ]; then
      app=${instance%_*}
      use=${instance##*_}
      app=$(echo ${app} | sed 's/_/-/g')
      RWVIP=$(echo "${VIPSTATUS}" | grep "${use}-${app}-rw")
      ROVIP=$(echo "${VIPSTATUS}" | grep "${use}-${app}-ro")
      if [ ${STATE} -eq 1 ]; then
         # We are read-only...
         if [ -n "${RWVIP}" ]; then
           RWMASTER=$(echo ${RWVIP} | grep '[M]' | wc -l)
           # ... but we have the RW VIP!
           if [ ${RWMASTER} -gt 0 -a ${IS_SLAVE} -eq 0 ]; then
             echo "   [!] ${instance} read-only with RW VIP"
             (( retcode++ ))
           fi
         fi
      fi
      [ -n "${RWVIP}" -a "${VERBOSE}" -eq 1 ] && echo "${RWVIP}"
      [ -n "${ROVIP}" -a "${VERBOSE}" -eq 1 ] && echo "${ROVIP}"
    fi
done

# Reset selected instance
select_instance ${current_instance}

exit ${retcode}
