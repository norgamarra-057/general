#!/usr/bin/env bash

# Global functions and variables

# Project dir
PDIR="$(dirname $0)/../../"

function msg()
{
  echo " [*] $@"
}

function err()
{
  echo " [!] $@"
}

function error()
{
  errcode=$1
  shift
  echo " [!] $@"
  exit $errcode
}

# SSH options
SSH_OPTIONS="-o BatchMode=yes -o StrictHostkeyChecking=no"

# Identify mysql environments and return as ansible groups
function get_mysql_clusters() {
  if [ $# -gt 0 ]; then
    pattern="$1"
  fi
  i=0
  local _GROUPS=""
  for environment in ${PDIR}/plays/envs/gds_{dub,sac,snc,lup}1_{prod,stg,uat,test}_db*.yml; do
    if [ $(expr "${environment}" : ".*${pattern}.*") -eq 0 ]; then
      continue
    fi
    cluster=$(basename ${environment%%.yml})
    # Skip those which didn't expand
    [[ "${cluster}" =~ .*\*.* ]] && continue
    if [ $i -eq 0 ]; then
      _GROUPS="${cluster}"
    else
      _GROUPS="${_GROUPS}:${cluster}"
    fi
    ((i++))
  done
  echo "${_GROUPS}"
}

# Print mysql environments in a human readable form
function print_mysql_clusters() {
  for _GROUP in $(list_mysql_clusters $@); do
    echo " [*] ${_GROUP}"
  done
}

function list_mysql_clusters() {
  for _GROUP in $(echo $@ | tr ':' ' '); do
    echo "${_GROUP}"
  done
}
