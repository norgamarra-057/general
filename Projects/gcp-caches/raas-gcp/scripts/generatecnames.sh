#!/bin/bash


if [ "$1" == "-h" ]; then
echo "
USAGE : generatecnames.sh FILE_NAME REGION ENVIRONMENT FORCE_CLEAN
PARAMETERS:
FILE_NAME         : Provide path to memorystore endpoints csv
REGION            : Provide a region. Values: us-central1
ENVIRONMENT       : Provide environment to which create terrabase variables. Values: dev, stable or prod.
FORCE_CLEAN       : (optional) Force clean cnames folder. Values clean or clean_sudo.

Example : generatecnames.sh filename.csv us-central1 stable
"
  exit 0
fi

if [[ $# -lt 3 ]]; then
    echo "Illegal number of parameters. Expected 3: FILE_NAME REGION ENVIRONMENT" >&2
    exit 1
fi

CSV_FILE_PATH=$1
CACHES_REGION=$2
CACHES_ENVIRONMENT=$3
CLEANUP=$4

if [ ! -f $CSV_FILE_PATH ]
then
    echo "File not found!"
    exit 1
fi

if [ ! $CACHES_REGION == "us-central1" ] && [ ! $CACHES_REGION == "europe-west1" ]
then
  echo "Illegal region. Please use us-central1 or europe-west1."
  exit 1
fi

if [ ! $CACHES_ENVIRONMENT == "dev" ] && [ ! $CACHES_ENVIRONMENT == "stable" ] && [ ! $CACHES_ENVIRONMENT == "prod" ]
then
  echo "Illegal environment. Please use one of dev, stable or prod."
  exit 1
fi

CSV_FILE="${CSV_FILE_PATH}_working"
VARIABLES_FILE="variables.hcl"
TERRAGRUNT_FILE="terragrunt.hcl"
CNAMES_PATH="../envs/${CACHES_ENVIRONMENT}/${CACHES_REGION}/cnames"

#Remove header line from exported csv file
tail -n +2 $CSV_FILE_PATH > $CSV_FILE

#Decide if we should clean existing cnames folder before generation
if [ "${CLEANUP}" == "clean" ]
then
  rm -Rf $CNAMES_PATH
  mkdir -p $CNAMES_PATH
elif [ "${CLEANUP}" == "clean_sudo" ]
then
  sudo rm -Rf $CNAMES_PATH
  mkdir -p $CNAMES_PATH
fi

while mapfile -t -n 22 ary && ((${#ary[@]})); do

    LINE_0="terraform {"
    LINE_1="${ary[1]}"
    LINE_2="${ary[2]}"
    LINE_3="${ary[3]}"
    LINE_4="${ary[4]}"
    LINE_5="${ary[5]}"
    LINE_6="${ary[6]}"
    LINE_7="${ary[7]}"
    LINE_8="${ary[8]}"
    LINE_9="${ary[9]}"
    LINE_10="${ary[10]}"
    LINE_11="${ary[11]}"
    LINE_12="${ary[12]}"
    CACHE_NAME=`echo $LINE_12 | sed -r 's/""/"/g' | awk -F "\"" '{print $2}'| awk -F "." '{print $1}'`
    LINE_12_X=`echo $LINE_12 | sed -r 's/""//g' | awk -F "=" '{print $2}'`
    LINE_13="${ary[13]}"
    LINE_14="${ary[14]}"
    LINE_15="${ary[15]}"
    LINE_15_X=`echo $LINE_15 | sed -r 's/""//g' | awk -F "=" '{print $2}'`
    LINE_16="${ary[16]}"
    LINE_16_X=`echo $LINE_16 | sed -r 's/""//g' | awk -F "=" '{print $2}'`
    LINE_17="${ary[17]}"
    LINE_18="${ary[18]}"
    LINE_19="${ary[19]}"
    LINE_20="${ary[20]}"
    LINE_21="${ary[21]}"

  if [ ! "${LINE_15_X}" == " ." ] && [ ! "${LINE_16_X}" == " ." ]
  then
    mkdir -p $CNAMES_PATH/$CACHE_NAME
#	  cat > $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE <<EOL
#terraform {
#  source = run_cmd(
#    "\${get_parent_terragrunt_dir()}/.terraform-tooling/bin/module-ref",
#    "redis-cname"
#  )
#}
#
#include {
#  path = find_in_parent_folders()
#}
#EOL

    echo $LINE_0 						| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_1 						| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_2 						| sed -r 's/""/"/g' 	| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_3 						| sed -r 's/""/"/g' 	| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_4 						| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_5 						| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_6 						| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_7 						| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_8 						| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_9 						| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_10 					| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_11 					| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_12 					| sed -r 's/""/"/g' 	| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_13           | tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_14           | tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_15           | sed -r 's/""/"/g' 	| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_16 					| sed -r 's/""/"/g' 	| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_17 					| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_18 					| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_19 					| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_20 					| tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE
    echo $LINE_21 					| sed -r 's/"//g' 	  | tee -a $CNAMES_PATH/$CACHE_NAME/$TERRAGRUNT_FILE

    printf -- '--- SNIP ---\n'
  fi

done < $CSV_FILE

#cleanup
rm -f $CSV_FILE
