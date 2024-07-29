#!/usr/bin/env bash

# Script to amend advbase of CARP VIPs
# rbarabas@groupon.com

VLAN=""
VHID=""
IPADDR=""
ADVBASE=5

function error()
{
  ret=$1
  shift
  echo " [!]" $@
  exit $ret
}

function msg()
{
  echo " [*]" $@
}

function get_config()
{
  ifconfig ${VLAN} 2>/dev/null | egrep ${IPADDR}
}

function get_vhid() 
{
  echo "${CONFIG}" | sed -n 's/.*vhid \([0-9]*\).*/\1/p'
}

function get_status()
{
  ifconfig "${VLAN}" | sed -n "s#[[:space:]]*carp: \([A-Z]*\).*vhid ${VHID}.*#\1#p"
}

function get_vips() 
{
  ifconfig ${VLAN} 2>/dev/null | \
    awk '{if ($1 == "inet" && $7 == "vhid"){ print $2 }}'
}

# Specify VLAN
VLAN=$1
[ -z "${VLAN}" ] && error 2 "please specify VLAN interface"

# For each IP, adjust settings in config and live
for IPADDR in $(get_vips); do
  CONFIG=$(get_config)

  # Get VHID 
  VHID=$(get_vhid "${CONFIG}")
  [ -z "${VHID}" ] && error 5 "vhid lookup failed: ${IPADDR}"
  
  # Get status
  STATE=$(get_status)
  
  if [ "${STATE}" == "BACKUP" ]; then
    msg "address ${IPADDR} vhid ${VHID} state ${STATE} -> nothing to do!"
    continue
  fi
  
  # Adjust advbase for VIP 
  ifconfig ${VLAN} vhid ${VHID} state BACKUP

  # Inform user
  msg "address ${IPADDR} vhid ${VHID} state ${STATE} -> BACKUP!"
done
