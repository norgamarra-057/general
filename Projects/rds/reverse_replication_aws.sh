#!/bin/bash

#######################################
# Defnition:
# This wscript will give you the list of availabe clusters on the selected region. It then waits for the users inputs. Exmaple is given below 
# Enter your AWS region (e.g., us-west-1): us-west-1
#       Available Aurora MySQL clusters in region us-west-1:
#       accounting-prod    ad-inv-serv-prod    aflrta-prod
# 
# Here you can choose any one DB cluster or you can type ALL. Base on the input received it will run and get you the replication status details 
#
# Author: Mohamedmoosa J
# Version: 2.0
#######################################

# Prompt for AWS region
read -p "Enter your AWS region (e.g., us-west-1): " AWS_REGION

# Set MySQL credentials from .my.cnf file
MYSQL_USER=$(grep 'user=' ~/.my.cnf | cut -d'=' -f2)
MYSQL_PASSWORD=$(grep 'password=' ~/.my.cnf | cut -d'=' -f2)

# Function to check replication status for a specific cluster
check_replication_status() {
  CLUSTER=$1

  # Get cluster details
  CLUSTER_DETAILS=$(aws rds describe-db-clusters --db-cluster-identifier $CLUSTER --region $AWS_REGION)

  echo "=================================================="
  echo "Checking replication status for cluster: $CLUSTER"
  echo "=================================================="

  # Get master endpoint
  MASTER_ENDPOINT=$(echo $CLUSTER_DETAILS | jq -r '.DBClusters[0].Endpoint')

  # Check replication status without showing the password warning
  mysql_output=$(mysql --host=$MASTER_ENDPOINT --user=$MYSQL_USER --password=$MYSQL_PASSWORD -s -e "SHOW SLAVE STATUS\G" | grep -E "Master_Host|Slave_IO_Running|Slave_SQL_Running|Seconds_Behind_Master|Slave_SQL_Running_State")
  
  echo "$mysql_output"
}

# Get list of Aurora MySQL clusters in the specified region
CLUSTERS=$(aws rds describe-db-clusters --query "DBClusters[?Engine=='aurora-mysql'].DBClusterIdentifier" --output text --region $AWS_REGION)

if [ -z "$CLUSTERS" ]; then
  echo "No Aurora MySQL clusters found in region $AWS_REGION."
  exit 1
fi

# Display available clusters
echo "Available Aurora MySQL clusters in region $AWS_REGION:"
echo "$CLUSTERS"
echo

# Prompt to choose a cluster or check all
read -p "Enter the name of the cluster to check replication status (or type 'ALL' to check all clusters): " CLUSTER_NAME

# If ALL is chosen, iterate over all clusters
if [ "$CLUSTER_NAME" == "ALL" ]; then
  for CLUSTER in $CLUSTERS; do
    check_replication_status $CLUSTER
  done
else
  # Check replication status for the specified cluster
  check_replication_status $CLUSTER_NAME
fi

