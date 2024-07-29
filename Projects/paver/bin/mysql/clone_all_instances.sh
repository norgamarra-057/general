#!/usr/bin/env bash

# Variables
SSH="ssh -o StrictHostKeyChecking=no -o BatchMode=yes "
MASTER_SERVER=
SLAVE_SERVER=
MYDIR=$(dirname $0)
ROOTDIR="${MYDIR}/../.."
PORT_START=9999
BANDWIDTH=20m
FORCE_CLONE=0

# Args
while getopts "m:s:b:f" opt; do
  case $opt in
    m) MASTER_SERVER=$OPTARG ;;
    s) SLAVE_SERVER=$OPTARG ;;
    b) BANDWIDTH=$OPTARG ;;
    f) FORCE_CLONE=1 ;;
  esac
done

function err() {
  errcode=$1
  shift
  echo "$@"
  exit ${errcode}
}

function usage() {
  echo "Usage: $0 -m master_server -s slave_server"
  exit 1
}

function check_instance() {
  server=$1
  instance=$2
  shift
  shift
  ${SSH} ${server} sudo check_repl.sh ${instance}
  return $?
}

[ -z "${MASTER_SERVER}" ] && usage
[ -z "${SLAVE_SERVER}" ] && usage

# Get instances
INSTANCES=$(${SSH} ${MASTER_SERVER} list_instances | awk '{ print $NF }')

PORT=${PORT_START}
for INSTANCE in ${INSTANCES}; do
  echo " [*] cloning ${INSTANCE}"
  LOGFILE=${HOME}/clone_${MASTER_SERVER}_${INSTANCE}.$(date +%Y%m%d).log
  # Instance health check
  if [ ${FORCE_CLONE} -eq 0 ]; then
    check_instance ${SLAVE_SERVER} ${INSTANCE}
    if [ $? -eq 0 ]; then
      continue
    else
      echo " [!] cloning instance"
    fi
  else
    echo " [!] cloning instance (forced)"
  fi
  (ansible-playbook ${ROOTDIR}/plays/mysql/clone-instance.yml -e master_server=${MASTER_SERVER} -e slave_server=${SLAVE_SERVER} -e instance=${INSTANCE} -e backup_stream_port=${PORT} >${LOGFILE} 2>&1) &
  ((PORT++))
done

# Wait for children to complete
echo " [*] waiting for jobs to complete..."
wait

echo " [*] done!"

