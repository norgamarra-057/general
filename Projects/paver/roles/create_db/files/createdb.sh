#!/bin/bash
#
# Shell to create sql statements to create database
# 
# Arguments :
# 1 - department
# 2 - application 
# 3 - environment ( stg/uat/dev/prod) 
# 4 - port of the instance
#

while test $# -gt 0; do
        case "$1" in
                -h|--help)
                        echo "Script to generate sql statements to create database"
                        echo " "
                        echo "options:"
                        echo "-h, --help                show brief help"
                        echo " "
                        echo "Parameters :"
                        echo "First place the department name"
                        echo "Second place the application name"
                        echo "Third place the environment type"
                        echo "Fourth place the port of the instance that will be created the database"
                        echo " "
                        echo "Please execute the statements generated as postgres user."
                        exit 0
                        ;;

    esac
if [ -z $1 ] 
then
	echo 'Argument for department is empty'
	exit
fi

if [ -z $2 ]
then
        echo 'Argument for application is empty'
        exit
fi

if [ -z $3 ]
then
        echo 'Argument for environment is empty'
        exit
fi

if [ -z $4 ]
then
        echo 'Argument for port is empty'
        exit
fi

password_dba=`cat /dev/random | hexdump -n 30 | cut -d \  -f 2- | head -n 1 | tr -d " "`
password_app=`cat /dev/random | hexdump -n 30 | cut -d \  -f 2- | head -n 1 | tr -d " "`


echo  "################ SQL STATEMENTS TO BE EXECUTED AS POSTGRES USER ################"
echo  "CREATE USER "$1"_"$2"_"$3"_dba PASSWORD '"$password_dba"' CONNECTION LIMIT 2;" 
echo  "CREATE USER "$1"_"$2"_"$3"_app PASSWORD '"$password_app"' CONNECTION LIMIT 10;"
echo  "CREATE DATABASE "$1"_"$2"_"$3" OWNER "$1"_"$2"_"$3"_dba;"
echo  "\c "$1"_"$2"_"$3
echo  "CREATE SCHEMA "$2";"
echo  "ALTER SCHEMA "$2" OWNER TO "$1"_"$2"_"$3"_dba;"
echo  "ALTER USER "$1"_"$2"_"$3"_dba set search_path = "$2";"
echo  "ALTER USER "$1"_"$2"_"$3"_app set search_path = "$2";"
echo  "\q"
echo  "psql -U "$1"_"$2"_"$3"_dba -d "$1"_"$2"_"$3" -p "$4
echo  "GRANT USAGE ON SCHEMA "$2" TO "$1"_"$2"_"$3"_app;"
echo  "ALTER DEFAULT PRIVILEGES IN SCHEMA "$2" GRANT SELECT,INSERT,UPDATE,DELETE ON TABLES TO "$1"_"$2"_"$3"_app;"
echo  "ALTER DEFAULT PRIVILEGES IN SCHEMA "$2" GRANT SELECT,UPDATE ON SEQUENCES TO "$1"_"$2"_"$3"_app;"
echo  "\q"
echo  "psql -U pgsql -d "$1"_"$2"_"$3" -p "$4
echo  "CREATE SCHEMA ext ;"
echo  "ALTER SCHEMA ext owner to  "$1"_"$2"_"$3"_dba;"
echo  "GRANT USAGE ON SCHEMA ext TO public ;"
echo  "GRANT USAGE ON SCHEMA ext TO "$1"_"$2"_"$3"_app;"
echo  "CREATE EXTENSION \"citext\" WITH SCHEMA ext;"
echo  "CREATE EXTENSION \"hstore\" WITH SCHEMA ext;"
echo  "CREATE EXTENSION \"uuid-ossp\" WITH SCHEMA ext;"
echo  "CREATE EXTENSION \"pg_stat_statements\" WITH SCHEMA ext;"


exit

done
