#!/bin/bash
#######################################
# Defnition:
# Run the script and select a number corresponding to the project (e.g., 1, 2, or 3). The script should properly set the PROJECT_ID based on your selection and proceed with the instance checks. Here the script will only check the replication status and logs all in a log file
# ---------------
# Expected Inputs
# ----------------
# Available GCP projects (GDS team):
#  1  prj-grp-gds-prod-daa8
#  2  prj-grp-gds-stable-63d2
#  3  prj-grp-gds-dev-4f99
# Enter the number corresponding to your GCP project: 1
#|+------------------------------------------------+
#|Scripts proceeds to check the replication status |
#|+------------------------------------------------+
# Author: Mohamedmoosa J
# Version: 2.0
#######################################

# Function to list available project IDs and prompt user to choose
choose_project_id() {
  echo "Available GCP projects (GDS team):"
  GDS_PROJECTS=$(gcloud projects list --format="value(projectId)" | grep -E '^prj-grp-gds-')
  echo "$GDS_PROJECTS" | nl -w 2 -s '  '

  read -p "Enter the number corresponding to your GCP project: " project_number
  PROJECT_ID=$(echo "$GDS_PROJECTS" | sed -n "${project_number}p")

  # Check if PROJECT_ID is empty
  if [ -z "$PROJECT_ID" ]; then
    echo "Invalid selection. Exiting."
    exit 1
  fi
}

# Set MySQL credentials from .my.cnf file
MYSQL_USER=$(grep 'user=' ~/.my.cnf | cut -d'=' -f2)
MYSQL_PASSWORD=$(grep 'password=' ~/.my.cnf | cut -d'=' -f2)

# Log file
#LOG_FILE="gcp_replication_status_log.txt"
LOG_FILE="gcp_replication_status_log_$(date +'%Y%m%d_%H%M%S').txt"

# Function to check instance status
check_instance_status() {
  INSTANCE_NAME=$1
  HOST=$2

  echo "==================================================" | tee -a $LOG_FILE
  echo "Checking instance: $INSTANCE_NAME" | tee -a $LOG_FILE
  echo "==================================================" | tee -a $LOG_FILE

  # Check if the instance is read-only
  READ_ONLY=$(mysql --user=$MYSQL_USER --password=$MYSQL_PASSWORD --host=$HOST -e "SHOW VARIABLES LIKE 'read_only';" -ss 2>/dev/null | awk '{print $2}')

  if [ "$READ_ONLY" == "ON" ]; then
    echo "$INSTANCE_NAME is a read-only slave instance." | tee -a $LOG_FILE
    echo "Checking replication status..." | tee -a $LOG_FILE
    mysql --user=$MYSQL_USER --password=$MYSQL_PASSWORD --host=$HOST -e "SHOW SLAVE STATUS\G" 2>/dev/null | grep -E "Master_Host|Slave_IO_Running|Slave_SQL_Running|Seconds_Behind_Master|Slave_SQL_Running_State" | tee -a $LOG_FILE
  else
    echo "$INSTANCE_NAME is a read-write master instance...." | tee -a $LOG_FILE
  fi
}

# Choose the project ID
choose_project_id

# Get all Cloud SQL instances that use MySQL engine, excluding ON_PREMISES_INSTANCE
INSTANCES=$(gcloud sql instances list --project="$PROJECT_ID" --filter="databaseVersion~MYSQL AND NOT instanceType:ON_PREMISES_INSTANCE" --format="value(name)")

for INSTANCE in $INSTANCES; do
  HOST=$(gcloud sql instances describe $INSTANCE --project="$PROJECT_ID" --format="value(ipAddresses[0].ipAddress)")
  check_instance_status $INSTANCE $HOST
done

echo "==================================================" | tee -a $LOG_FILE
echo "Replication status check completed." | tee -a $LOG_FILE
echo "Log file saved to $LOG_FILE"

