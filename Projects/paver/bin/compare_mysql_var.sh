#!/bin/sh
#########
# Crude shell script that creates a list of variables to query a server for, then generates a report for each
#########

while getopts ":s:v:" opt; do
    case $opt in
        s)
            server=$OPTARG
            ;;
        v)
            variables=$OPTARG
            ;;
        \?)
            echo "Usage: -s server_name -v list_of_variables (space delimited)"
            exit 0;;
    esac
done

for variable_name in $variables
do
	ansible-playbook -i inventory plays/check/compare_mysql_var.yml -e "node=${server} mysql_check=${variable_name}"
done
