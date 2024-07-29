#!/usr/bin/env sh

set -e

MYARGS=
THISHOST=$(hostname)

usage() {
   echo "$0 -S <socket> -u <username> -p <password>"
   exit 3
}

while getopts "u:p:H:P:S:" opt; do
  case "${opt}" in
    u) [ -z "${MYUSER}" ] && MYUSER="${OPTARG}" && MYARGS="${MYARGS} --user=${MYUSER}" ;;
    p) [ -z "${MYPASS}" ] && MYPASS="${OPTARG}" && MYARGS="${MYARGS} --password=${MYPASS}" ;;
    H) [ -z "${MYHOST}" ] && MYHOST="${OPTARG}" && MYARGS="${MYARGS} --host=${MYHOST}" ;;
    P) [ -z "${MYPORT}" ] && MYPORT="${OPTARG}" && MYARGS="${MYARGS} --port=${MYPORT}" ;;
    S) [ -z "${MYSOCKET}" ] && MYSOCKET="${OPTARG}" && MYARGS="${MYARGS} --socket=${MYSOCKET}" ;;
    *) usage ;;
  esac
done

# Check if the VIP is configured locally
CONNHOST=$(mysql ${MYARGS} -e "system hostname")

[ "${THISHOST}" = "${CONNHOST}" ] && exit 0 || exit 2

