#!/usr/bin/env bash

DIRNAME=$(which dirname)
if [[ ! -x $DIRNAME ]]
then
        echo "ERROR - DIRNAME is not set up properly. Exiting ..." >&2
        exit 1
fi

BaseDir="$(cd "$($DIRNAME "${BASH_SOURCE[0]}" )" && pwd )"
BaseDir=${BaseDir%/*}
BaseName=get_state
TmpDir=/tmp
TmpFile=${TmpDir}/${BaseName}.$$
SQLDir=${BaseDir}/sql
SQLFile=${SQLDir}/get_connections.sql

ExitStatus=0

check_connection() {
	DBID=$1

	echo "Checking maximum number of connections in last 24 hours for -> $DBID"

	StartTime=$(date -u +%Y-%m-%dT%H:%M:%SZ --date "yesterday")
	EndTime=$(date -u +%Y-%m-%dT%H:%M:%SZ)

	conn=$(aws cloudwatch get-metric-statistics --namespace AWS/RDS --metric-name DatabaseConnections --start-time $StartTime --end-time $EndTime --period 86400 --statistics Maximum --dimensions Name=DBInstanceIdentifier,Value=$DBID | grep Maximum | awk '{printf("%d", substr($2,1,length($2)-1))}')
	if [[ $conn -gt 0 ]]
	then
		echo "ERROR: $conn Connection(s) found"
		ExitStatus=1
	else 
		echo "No Connections found"
	fi
}

check_cluster_connections() {
	identifier=$(awk '{if ($1 == "identifier") {print $3}}' $TmpFile)
	eval "identifier=$identifier"

	check_connection $identifier
}

check_instance_connections() {
	identifier=$(awk '{if ($1 == "identifier") {print $3}}' $TmpFile)
	eval "identifier=$identifier"

	check_connection $identifier
}

# Turn off color output
export TF_CLI_ARGS="-no-color"

if [[ $# -ne 1 ]]
then
	echo "ERROR: One parameter is required -> working directory"
	exit 1
fi

Directory=$1
echo "Changing directory to $Directory ..."
cd $Directory

echo "Getting the state list ..."
# Get the state
for resource in `terragrunt state list 2>/dev/null`
do
        echo "Found -> $resource"
        # For each item in the list get the output
        terragrunt state show $resource 2>/dev/null > $TmpFile
        if [[ $? -ne 0 ]]
        then
                echo "ERROR: Unable to get state for $resource" >&2
                exit 1
        fi

        # The first line shows the information about that item - we are only interested in resources
        read typ typName dummy <<< $(grep -v "^#" $TmpFile | head -1)

        if [[ $typ = "resource" ]]
        then
		echo "Checking resource $typName ..."
                # We only care about instances and clusters
                case $typName in
                        \"aws_db_instance\")          check_instance_connections ;;
                        \"aws_rds_cluster_instance\") check_cluster_connections ;;
			*)                            echo "Not a resource that has db connections" ;;
                esac
        fi
done

rm -f $TmpFile

exit $ExitStatus
