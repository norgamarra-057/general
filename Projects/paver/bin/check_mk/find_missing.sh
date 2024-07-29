#!/usr/bin/env bash

# Variables
#CHECK_MK_SERVERS="mon1.dub1 mon2.dub1 mon1.sac1 mon2.sac1 mon1-staging.snc1 mon2-staging.snc1"
CHECK_MK_SERVERS="mon1-staging.snc1 mon2-staging.snc1"
DATACENTER="${HOST#*.}"
USE=prod

function usage()
{
    echo "Usage: $0 [-d datacenter] [-p] [-s] [-u]"
    echo "  -d <datacenter>  datacenter"
    echo "  -p               production"
    echo "  -s               staging"
    echo "  -u               uat"
    exit 1
}

while getopts "d:psu" opt; do
  case ${opt} in
    d)      DATACENTER=${OPTARG} ;;
    p)      USE="prod" ;;
    s)      USE="stg" ;;
    u)      USE="uat" ;;
    *|h)    usage ;;
  esac
done

case $USE in
    prod)   CHECK_MK_SERVERS="mon1.${DATACENTER} mon2.${DATACENTER}" ;;
    stg)    CHECK_MK_SERVERS="mon1-staging.${DATACENTER} mon2-staging.${DATACENTER}" ;;
    uat)    CHECK_MK_SERVERS="mon1-staging.${DATACENTER} mon2-staging.${DATACENTER}" ;;
    *)      CHECK_MK_SERVERS="mon1-staging.${DATACENTER} mon2-staging.${DATACENTER}" ;;
esac

function setup()
{
  LOCAL_HOSTS=$(mktemp /tmp/repo_hosts.${DATACENTER}.XXXXXX)
  CHECK_MK_HOSTS=$(mktemp /tmp/check_mk_hosts.${DATACENTER}.XXXXXX)
}

function cleanup()
{
  rm ${LOCAL_HOSTS} ${CHECK_MK_HOSTS}
}

function test_ssh() {
  echo " [i] testing ssh to ${SERVER}"
  ssh -o BatchMode=yes -o StrictHostKeyChecking=no $1 w >/dev/null
}

function get_check_mk_hosts()
{
  echo " [*] obtaining list of hosts from check_mk"
  for SERVER in ${CHECK_MK_SERVERS}; do
    test_ssh ${SERVER} || exit 123
    ssh -o BatchMode=yes -o StrictHostKeyChecking=no ${SERVER} \
      grep gds /etc/check_mk/main.mk 2>/dev/null | \
        tr -d '"' | cut -d'|' -f1 | sort >> ${CHECK_MK_HOSTS}
  done
}

function get_repo_hosts()
{
  echo " [*] obtaining list of hosts from repository"
  ansible -m ping gds_all --list-hosts | grep gds-${DATACENTER}-${USE} | \
    sed 's/^[ ]*//g' | sort > ${LOCAL_HOSTS}
}

# Main
echo " [*] Looking for missing hosts in ${DATACENTER} ${USE}"
setup
get_check_mk_hosts
get_repo_hosts
LIST=$(comm -23 ${LOCAL_HOSTS} ${CHECK_MK_HOSTS})
if [ "$(echo ${LIST} | grep '[a-z]' | wc -l)" -gt 0 ]; then
  echo " [!] Hosts missing:"
  for H in ${LIST}; do
    echo "${H}"
  done
fi
cleanup
