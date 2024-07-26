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

check_cluster_connections() {
        echo "Checking cluster connections ..."
        # Ensure that the engine is postgres
        engine=$(awk '{if ($1 == "engine") {print $3}}' $TmpFile)
        eval "engine=$engine"  # remove quotes

        if [[ $engine = "aurora-postgresql" ]]
        then
                # Extract host, port and username
                host=$(awk '{if ($1 == "endpoint") {print $3}}' $TmpFile)
                eval "PGHOST=$host" # remove quotes
                if [[ -z $PGHOST ]]
                then
                        echo "ERROR: Unable to get host details" >&2
                        exit 1
                fi
                export PGHOST
                echo "Host = $PGHOST"

                # Extract the port
                port=$(awk '{if ($1 == "port") {print $3}}' $TmpFile)
                eval "PGPORT=$port" # remove quotes
                if [[ -z $PGPORT ]]
                then
                        echo "ERROR: Unable to get port details" >&2
                        exit 1
                fi
                export PGPORT
                echo "Port = $PGPORT"
                
		check_connection

		# Unset the variables 
		unset PGHOST
		unset PGPORT
        fi
}

check_connection() {
	conn=$(psql -tf $SQLFile)
	conn=$(echo $conn)
	if [[ $conn -gt 0 ]]
	then
		echo "ERROR: $conn Connection(s) found" >&2
		ExitStatus=1
	else
		echo "No connections found"
	fi
}

check_instance_connections() {
        echo "Checking connections ..."
        # Ensure that the engine is postgres
        engine=$(awk '{if ($1 == "engine") {print $3}}' $TmpFile)
        eval "engine=$engine"  # remove quotes

        if [[ $engine = "postgres" ]]
        then
                # Extract host, port and username
                host=$(awk '{if ($1 == "address") {print $3}}' $TmpFile)
                eval "PGHOST=$host" # remove quotes
                if [[ -z $PGHOST ]]
                then
                        echo "ERROR: Unable to get host details" >&2
                        exit 1
                fi
                export PGHOST
                echo "Host = $PGHOST"

                # Extract the port
                port=$(awk '{if ($1 == "port") {print $3}}' $TmpFile)
                eval "PGPORT=$port" # remove quotes
                if [[ -z $PGPORT ]]
                then
                        echo "ERROR: Unable to get port details" >&2
                        exit 1
                fi
                export PGPORT
                echo "Port = $PGPORT"
                
                # Extract the port
                user=$(awk '{if ($1 == "username") {print $3}}' $TmpFile)
                eval "PGUSER=$user" # remove quotes
                if [[ -z $PGUSER ]]
                then
                        echo "ERROR: Unable to get user details" >&2
                        exit 1
                fi
                export PGUSER
                echo "User = $PGUSER"

                #Extract the database
                db=$(awk '{if ($1 == "name") {print $3}}' $TmpFile)
                eval "PGDATABASE=$db" # remove quotes#
                if [[ -z $PGDATABASE ]]
                then
                        echo "ERROR: Unable to get database details" >&2
                        exit 1
                fi
                export PGDATABASE
                echo "Database = $PGDATABASE"

                # Get the password
                if [[ -z $PGPASSWORD ]]
                then
                        # Try to find password from terragrunt file -> module-specific.tfvars
                        if [[ ! -f module-specific.tfvars ]]
                        then
                                passwd=$(awk '{if ($1 == "admin-password") {print $3}}' module-specific.tfvars)
                                if [[ -z $passwd ]] 
				then
                                        echo "ERROR - Unable to find password for database" >&2
                                        exit 1
				fi
                                eval "PGPASSWORD=$passwd"
                                export PGPASSWORD
                        fi
                fi

		check_connection

		# Unset the variables 
		unset PGHOST
		unset PGPORT
		unset PGDATABASE
		unset PGUSER
        fi
}

get_cluster_info() {
        echo "Getting cluster information ..."
        # Ensure that the engine is postgres
        engine=$(awk '{if ($1 == "engine") {print $3}}' $TmpFile)
        eval "engine=$engine"  # remove quotes

        if [[ $engine = "aurora-postgresql" ]]
        then
                # Extract the port
                user=$(awk '{if ($1 == "master_username") {print $3}}' $TmpFile)
                eval "PGUSER=$user" # remove quotes
                if [[ -z $PGUSER ]]
                then
                        echo "ERROR: Unable to get user details" >&2
                        exit 1
                fi
                export PGUSER
                echo "User = $PGUSER"

                #Extract the database
                db=$(awk '{if ($1 == "database_name") {print $3}}' $TmpFile)
                eval "PGDATABASE=$db" # remove quotes#
                if [[ -z $PGDATABASE ]]
                then
                        echo "ERROR: Unable to get database details" >&2
                        exit 1
                fi
                export PGDATABASE
                echo "Database = $PGDATABASE"

                # Get the password
                if [[ -z $PGPASSWORD ]]
                then
                        # Try to find password from terragrunt file -> module-specific.tfvars
                        if [[ ! -f module-specific.tfvars ]]
                        then
                                passwd=$(awk '{if ($1 == "admin-password") {print $3}}' module-specific.tfvars)
                                if [[ -z $passwd ]] 
				then
                                        echo "ERROR - Unable to find password for database" >&2
                                        exit 1
				fi
                                eval "PGPASSWORD=$passwd"
                                export PGPASSWORD
                        fi
                fi
        fi
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
                        \"aws_rds_cluster\")          get_cluster_info ;;
                        \"aws_rds_cluster_instance\") check_cluster_connections ;;
			*)                            echo "Not a resource that has db connections" ;;
                esac
        fi
done

rm -f $TmpFile

exit $ExitStatus
