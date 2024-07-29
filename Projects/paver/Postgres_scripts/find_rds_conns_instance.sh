#!/usr/bin/env bash

function find_database {
    Vip="$1"
    result=$(psql -p 5432 -h $Vip -t -U gds_admin -d postgres -c "select datname from pg_stat_database where datname not in ('template0','template1','postgres','rdsadmin') order by
1")
    echo "***************************************************Available databases:"
    echo "-------------------------------------------------------------------------------------------"
    echo "${result}"
    echo "-------------------------------------------------------------------------------------------"
}


function find_connections {
    Vip="$1"
    Dbname="$2"
    result=$(psql -p 5432 -h $Vip -d $Dbname -t -U gds_admin -c "select usename,client_addr,count(*) from pg_stat_activity where datname='$Dbname' group by 1,2 order by 3 desc")
    echo "****************************************************Connections:"
    echo "${result}"
    echo "--------------------------------------------------------------------------------------------------------------------------------"
}


if [ $# -lt 1 ]; then
    echo 'no argument given'
    exit 1
elif [ $# -gt 2 ]; then
    echo 'too many arguments'
    exit 1
fi



    vip="$1"
    dbname="$2"

    if [ -z "${dbname}" ]; then find_database ${vip}; else echo "dbname is set to '$dbname'"; fi
    if [ -z "${dbname}" ]; then read -p "Enter database name: " dbname; fi

    find_connections ${vip} ${dbname}