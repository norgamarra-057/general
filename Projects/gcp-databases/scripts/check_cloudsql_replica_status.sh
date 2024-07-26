#!/bin/bash

# Prompt for project ID
read -p "Enter your GCP project ID: " PROJECT_ID

# Set MySQL credentials from .my.cnf file
MYSQL_USER=$(grep 'user=' ~/.my.cnf | cut -d'=' -f2)
MYSQL_PASSWORD=$(grep 'password=' ~/.my.cnf | cut -d'=' -f2)

# Log file
LOG_FILE="replication_status_log.txt"

# Function to check instance status
check_instance_status() {
  INSTANCE_NAME=$1
  HOST=$2

  echo "Checking instance: $INSTANCE_NAME" | tee -a $LOG_FILE

  # Check if the instance is read-only
  READ_ONLY=$(mysql --user=$MYSQL_USER --password=$MYSQL_PASSWORD --host=$HOST -e "SHOW VARIABLES LIKE 'read_only';" -ss | awk '{print $2}')

  if [ "$READ_ONLY" == "ON" ]; then
    echo "$INSTANCE_NAME is a read-only slave instance." | tee -a $LOG_FILE
    echo "Checking replication status..." | tee -a $LOG_FILE
    mysql --user=$MYSQL_USER --password=$MYSQL_PASSWORD --host=$HOST -e "SHOW SLAVE STATUS\G" | tee -a $LOG_FILE

    # Check for the skipReplicationError procedure
    echo "Checking for skipReplicationError procedure..." | tee -a $LOG_FILE

    SKIP_REPLICATION_ERROR=$(mysql --user=$MYSQL_USER --password=$MYSQL_PASSWORD --host=$HOST -e "SELECT ROUTINE_NAME, ROUTINE_SCHEMA FROM information_schema.ROUTINES WHERE ROUTINE_NAME = 'skipReplicationError';" -ss)

    if [ -z "$SKIP_REPLICATION_ERROR" ]; then
      echo "Skip Replication Error Procedure is not installed." | tee -a $LOG_FILE
    else
      echo "Skip Replication Error Procedure is added." | tee -a $LOG_FILE
    fi

  else
    echo "$INSTANCE_NAME is a master instance." | tee -a $LOG_FILE
    echo "Capturing activity..." | tee -a $LOG_FILE
    mysql --user=$MYSQL_USER --password=$MYSQL_PASSWORD --host=$HOST -e "SELECT count(*), id, user, db, host FROM information_schema.processlist GROUP BY user;" | tee -a $LOG_FILE
  fi
}

# Get all Cloud SQL instances that use MySQL engine and are read replicas
INSTANCES=$(gcloud sql instances list --project=$PROJECT_ID --format="value(name)" --filter="databaseVersion~MYSQL AND instanceType:READ_REPLICA_INSTANCE")

for INSTANCE in $INSTANCES; do
  HOST=$(gcloud sql instances describe $INSTANCE --project=$PROJECT_ID --format="value(ipAddresses[0].ipAddress)")
  check_instance_status $INSTANCE $HOST
done
