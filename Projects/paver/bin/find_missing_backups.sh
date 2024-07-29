#!/bin/sh
###################################################
# find_missing_backups.sh
#
# Version:      1.0.0
#
# Author:       Juan Rodriguez Donoso, with broken stuff provided by David Minor
#
# Descripton:   Parses both paver and delorean repos to deterine Database VIPS that are not setup to be backed up
#
# Usage:        find_missing_backups.sh [-e <prod|stg|uat|test>] [-d <snc1|dub1|sac1>] [-p <path_to_paver_root> [-b <path_to_delorean_root>]
#
# Optional arguments:
#   -e environment to parse.  Default is 'prod'
#   -d datacenter to parse.  Default is snc1
#   -p path to paver repo.  Default is ..  Assumes the script is running from paver/bin
#   -b path to delorean repo.  Default is ../../delorean
#
# Requirements: shyamal
#
# Notes:        Must be run from the paver/bin directory.
#               delorean repo must be installed: git clone git@github.groupondev.com:syseng/delorean.git
###################################################

# Default values
ENV=prod
DC=snc1
PAVER=..
DELOREAN=../../delorean
COUNT=0

usage() { 
    echo "Usage: $0 [-e <prod|stg|uat|test>] [-d <snc1|dub1|sac1>] [-p <path_to_paver_root> [-b <path_to_delorean_root>]" 1>&2; exit 1; 
}

while getopts ":e:d:p:b:" option; do
    case "${option}" in
        e)
            ENV=${OPTARG}
            ;;
        d)
            DC=${OPTARG}
            ;;
        p)
            PAVER=${OPTARG}
            ;;
        b)
            DELOREAN=${OPTARG}
            ;;
        :)  
            echo "ERROR: Option -$OPTARG requires an argument"
            usage
            ;;
        \?)
            echo "ERROR: Invalid option -$OPTARG"
            usage
            ;;
    esac
done

# Verify PAVER and DELOREAN paths
stat ${PAVER}/inventory/group_vars > /dev/null 2>&1
if [ $? != 0 ]
then
    echo
    echo "Path to Paver repo: '${PAVER}' is invalid or does not exist."
    echo "Note: $0 must be run from the paver/bin directory."
    echo
    usage
fi

stat ${DELOREAN}/inventory/group_vars > /dev/null 2>&1
if [ $? != 0 ]
then
    echo
    echo "Path to Deloran repo: '${DELOREAN}' is invalid or does not exist."
    echo "Note: $0 must be run from the paver/bin directory."
    echo
    usage
fi
	
FILE_LIST=`ls ${PAVER}/inventory/group_vars | grep gds| grep $ENV | grep $DC |grep -v admin`

for FILE in $FILE_LIST
do
    echo
    echo \####################################################################
    echo \# Cluster ${PAVER}/inventory/group_vars/$FILE
    echo \# VIPS not backed up

    INSTANCE_LIST=`cat ${PAVER}/inventory/group_vars/$FILE | shyaml keys-0 gds_instances | xargs -0 -n 1`
    for INSTANCE in $INSTANCE_LIST
    do
        SLAVE_IP=`cat ${PAVER}/inventory/group_vars/$FILE | shyaml get-value gds_instances.$INSTANCE.slave_vips | sed -e 's/- //g'`
        SLAVE_DNS=`host $SLAVE_IP`
        if [ $? -eq 0 ]
        then
          DNS=`echo $SLAVE_DNS | awk '{print $5}' | sed -e 's/.$//g'`
          grep $DNS ${DELOREAN}/inventory/delorean-${ENV}-${DC}*  > /dev/null 2>&1
          if [ $? != 0 ]
          then
              echo $DNS
              let "COUNT=COUNT+1" > /dev/null 2>&1
          fi
        else
          echo "# DNS not found for $INSTANCE -------------------> $SLAVE_IP" >&2
        fi
    done
done

echo ========================================================
echo Total of Missing Backups $COUNT
