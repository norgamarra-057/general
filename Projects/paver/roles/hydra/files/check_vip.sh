#!/usr/bin/env bash
# set -x

TARGET_VIP="$1"

if [ -z "$TARGET_VIP" ]
then
  >&2 echo "You must specify a target VIP to check"
  exit 1
fi

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
    if [ "$TARGET_VIP" != "$VIP" ]
    then
      continue
    fi

    STATE="${STATES[$VHID]}"
    REVERSE="$(host ${VIP} | awk '{print $NF}')"
    case "${STATE}" in
      "MASTER")
        echo "   [M] ${VIP} (${REVERSE})"
        exit 0
        ;;
      "BACKUP")  
        >&2 echo "   [S] ${VIP} (${REVERSE})"
        exit 1
        ;;
      *)  
        >&2 echo "   [!] ${VIP} (${REVERSE})"
        exit 1
        ;;
    esac
  done
done

>&2 echo "VIP $TARGET_VIP not found"
exit 1
