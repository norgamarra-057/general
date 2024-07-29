#!/usr/bin/env bash

# just pass in a port.  Examples:
#
# ./port-to-ip.sh 20002
#  LoopbackPort 20002 : Type mysql : killbill_prod : IP 10.30.32.56 : vhid 56
#  LoopbackPort 20002 : Type mysql : killbill_prod : IP 10.30.33.56 : vhid 56
#
# ./port-to-ip.sh 20187
#  LoopbackPort 20187 : Type postgresql : tgt_dealmsg_stg : IP 10.23.32.203 : vhid 203
#  LoopbackPort 20187 : Type postgresql : tgt_dealmsg_stg : IP 10.23.33.203 : vhid 203
#

DEBUG=0

LO_PORT=$1
if [[ "$DEBUG" == 1 ]]
then
   echo "LO_PORT = $LO_PORT"
fi
LO_PORT_INFO="`/sbin/pfctl -s nat 2> /dev/null | grep $LO_PORT | grep gds-client`"
if [[ "$DEBUG" == 1 ]]
then
   echo "LO_PORT_INFO = $LO_PORT_INFO"
fi
SVC_TYPE=`echo "$LO_PORT_INFO" | awk '{print $11}'`
if [[ "$DEBUG" == 1 ]]
then
  echo "SVC_TYPE = $SVC_TYPE"
fi

SVC_NAME=`echo "$LO_PORT_INFO" | awk '{print $8}' | sed 's/<//' | sed 's/>//'`
if [[ "$DEBUG" == 1 ]]
then
  echo "SVC_NAME = $SVC_NAME"
fi
SVC_VIPS=`/sbin/pfctl -t $SVC_NAME -T show  2> /dev/null `
if [[ "$DEBUG" == 1 ]]
then
  echo "SVC_VIPS = $SVC_VIPS"
fi

for IP in $SVC_VIPS
do
  SVC_VHID=`ifconfig | grep $IP | awk '{print $8}'`
  if [[ "$DEBUG" == 1 ]]
  then
    echo "IP SVC_VHID = $IP $SVC_VHID"
  fi
  echo "LoopbackPort $LO_PORT : Type $SVC_TYPE : `echo $SVC_NAME | sed 's/-vips//' | sed 's/gds-//'` : IP $IP : vhid $SVC_VHID"
done