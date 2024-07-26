#! /usr/bin/env bash
#set -xv
echo ".....Getting the hosted zones & records for STABLE..........." 
aws route53  list-hosted-zones|jq '.[] | .[] | .Id' | sed 's!/hostedzone/!!' | sed 's/"//g' > zones
for i in $( awk '{ print $1 }' zones); do printf "%s\n\n" "Hosted Zone ID : ${i}"; aws-okta exec stable -- aws route53 list-resource-record-sets --hosted-zone-id ${i} | jq -r '.ResourceRecordSets[]? | "\(.Name),\(.Type),\(.ResourceRecords[]?.Value)"'| grep -i gds; sleep 1; done
