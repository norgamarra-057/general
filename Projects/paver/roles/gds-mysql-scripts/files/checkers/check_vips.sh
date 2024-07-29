#!/usr/bin/env bash
# set -x

VLAN_INTERFACES=$(ifconfig 2>/dev/null | grep ^vlan | cut -d':' -f1)

for VLAN in $VLAN_INTERFACES; do
  echo " [*] looking for VIPs on ${VLAN}"
  VIPS=()
  VIPLINES=$(ifconfig ${VLAN} | awk '{if ($1 ~ /inet/ && $7 ~ /vhid/){ print $8 ":" $6 }}')

  # Identify VIPs based on VHIDs
  i=0
  for VIPLINE in ${VIPLINES}; do
    VHID=$(echo ${VIPLINE} | cut -d':' -f1)
    ADDR=$(echo ${VIPLINE} | cut -d':' -f2)
    VIPS[$VHID]="${ADDR}"
  done

  # Add state to VIPs
  STATELINES=$(ifconfig ${VLAN} | awk '{if ($1 ~ /carp/){ print $4 ":" $2 }}')
  i=0
  for STATELINE in ${STATELINES}; do
    VHID=$(echo ${STATELINE} | cut -d':' -f1)
    STATE=$(echo ${STATELINE} | cut -d':' -f2)
    STATES[$VHID]="${STATE}"
  done

  for VHID in ${!VIPS[@]}; do
    VIP="${VIPS[$VHID]}"
    REVERSE="$(host ${VIP} | awk '{print $NF}')"
    STATE="${STATES[$VHID]}"
    case "${STATE}" in
      "MASTER")
        echo "   [M] ${VIP} (${REVERSE})"
        ;;
      "BACKUP")  
        echo "   [S] ${VIP} (${REVERSE})"
        ;;
      *)  
        echo "   [!] ${VIP} (${REVERSE})"
        ;;
    esac
  done
  echo
done
