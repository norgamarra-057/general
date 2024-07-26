#!/bin/bash

# Function to read MySQL credentials from .my.cnf
read_mysql_credentials() {
    local cnf_file="$HOME/.my.cnf"
    db_user=$(awk -F "=" '/user/ {print $2}' "$cnf_file" | xargs)
    db_password=$(awk -F "=" '/password/ {print $2}' "$cnf_file" | xargs)
}

# Function to run SQL commands on AWS
run_aws_sql() {
    local endpoint="$1"
    local sql="$2"
    echo "Running SQL on AWS: $sql"
    mysql -h "$endpoint" -u "$db_user" -p"$db_password" -e "$sql"
}

# Function to run SQL commands on GCP
run_gcp_sql() {
    local sql="$1"
    echo "Running SQL on GCP: $sql"
    mysql -h "$gcp_ip" -u "$db_user" -p"$db_password" -e "$sql"
}

# Function to check replication status
check_replication_status() {
    local slave_status="$1"
    local io_running=$(echo "$slave_status" | grep "Slave_IO_Running: Yes")
    local sql_running=$(echo "$slave_status" | grep "Slave_SQL_Running: Yes")
    local seconds_behind_master=$(echo "$slave_status" | grep "Seconds_Behind_Master: 0")

    if [[ -n $io_running && -n $sql_running && -n $seconds_behind_master ]]; then
        return 0
    else
        return 1
    fi
}

# Read MySQL credentials from .my.cnf
read_mysql_credentials

# Prompt for AWS endpoint and GCP IP
read -p "Enter the AWS endpoint: " aws_endpoint
read -p "Enter the GCP IP: " gcp_ip

# Extract the base name for the log file from the AWS endpoint
base_name=$(echo "$aws_endpoint" | cut -d'.' -f1)
log_file="${base_name}.pre_cutover.log"

# Redirect all output to the log file
exec > >(tee -i "$log_file") 2>&1

# Display cutover process steps
echo "============================================================"
echo "Pre-Cutover process initiated. Below are the steps involved:"
echo "============================================================"
echo "1. Validate the replication is working from AWS to GCP"
echo "2. Check the SkipReplErr Procedure on GCP"
echo "3. Set up reverse replication from GCP to AWS"
echo "4. Validate the replication is working from AWS to GCP again"
echo "5. Validate the data from GCP and AWS"
echo "============================================================"

# Step 1: Validate the replication is working from AWS to GCP
echo "Step 1: Validate the replication is working from AWS to GCP"
gcp_slave_status=$(run_gcp_sql "SHOW SLAVE STATUS \G")

echo "Slave status on GCP:"
echo "$gcp_slave_status"

if check_replication_status "$gcp_slave_status"; then
    echo "Replication from AWS to GCP is working fine."
else
    echo "Replication from AWS to GCP is not working correctly. Please check the slave status."
    read -p "Do you want to proceed with the next steps? (yes/no): " proceed_gcp_replication
    if [ "$proceed_gcp_replication" != "yes" ]; then
        echo "Exiting the cutover process."
        exit 0
    fi
fi

# Display the next step
echo "Next Step: Step 2 - Check the SkipReplErr Procedure on GCP"

# Step 2: Check the SkipReplErr Procedure on GCP
echo "Step 2: Check the SkipReplErr Procedure on GCP"

# Check if skip replication error procedure exists on GCP
skip_proc_exists=$(run_gcp_sql "SELECT ROUTINE_NAME, ROUTINE_SCHEMA FROM information_schema.ROUTINES WHERE ROUTINE_NAME = 'skipReplicationError';")

if [[ -n $skip_proc_exists ]]; then
    echo "skipReplicationError procedure exists on GCP."
else
    echo "skipReplicationError procedure does not exist on GCP."
    read -p "Do you want to proceed further? (yes/no): " user_input
    if [[ $user_input != "yes" ]]; then
        echo "Exiting."
        exit 1
    fi
fi

# Display the next step
echo "Next Step: Step 3 - Set up reverse replication from GCP to AWS"

# Step 3: Set up reverse replication from GCP to AWS
echo "Step 3: Set up reverse replication from GCP to AWS"

# Stop replication on GCP
run_gcp_sql "CALL mysql.stopReplication();"

#Capture GCP binary log co-ordinates
master_status=$(run_gcp_sql "SHOW MASTER STATUS \G")

echo "Master status on GCP:"
echo "$master_status"
echo "$gcp_ip"

gcp_binlog_file=$(echo "$master_status" | awk '/File/ {print $2}')
gcp_binlog_position=$(echo "$master_status" | awk '/Position/ {print $2}')

if [[ -z $gcp_binlog_file || -z $gcp_binlog_position ]]; then
    echo "Failed to retrieve GCP binlog information. Exiting."
    exit 1
fi

# Set up reverse replication from GCP to AWS
reverse_replication_sql="CALL mysql.rds_set_external_master ('$gcp_ip', 3306, 'replication', 'GaSxrz1twblgEyl', '$gcp_binlog_file', $gcp_binlog_position, 0);"
start_replication_sql="CALL mysql.rds_start_replication;"
run_aws_sql "$aws_endpoint" "$reverse_replication_sql"
run_aws_sql "$aws_endpoint" "$start_replication_sql"

# Check replication status every 5 seconds for 30 seconds
for i in {1..6}; do
    sleep 5
    aws_slave_status=$(run_aws_sql "$aws_endpoint" "SHOW SLAVE STATUS \G")
    echo "Slave status on AWS (Attempt $i):"
    echo "$aws_slave_status"

    error_status=$(echo "$aws_slave_status" | grep "Last_Error:")
    if [[ -n $error_status ]]; then
        echo "Error detected in replication: $error_status"
        read -p "Do you want to proceed or bail out? (proceed/bail): " proceed_bail
        if [ "$proceed_bail" == "bail" ]; then
            echo "Bailing out of the cutover process."
            exit 1
        fi
    fi
done

# Start replication on GCP
run_gcp_sql "CALL mysql.startReplication();"

read -p "Do you want to proceed with the next steps? (yes/no): " proceed_reverse_replication
if [ "$proceed_reverse_replication" != "yes" ]; then
    echo "Exiting the cutover process."
    exit 0
fi

# Display the next step
echo "Next Step: Step 4 - Validate the replication is working from AWS to GCP again"

# Step 4: Validate the replication is working from AWS to GCP again
echo "Step 4: Validate the replication is working from AWS to GCP again"
gcp_slave_status=$(run_gcp_sql "SHOW SLAVE STATUS \G")

echo "Slave status on GCP:"
echo "$gcp_slave_status"

if check_replication_status "$gcp_slave_status"; then
    echo "Replication from AWS to GCP is working fine."
else
    echo "Replication from AWS to GCP is not working correctly. Please check the slave status."
    read -p "Do you want to proceed with the next steps? (yes/no): " proceed_final_validation
    if [ "$proceed_final_validation" != "yes" ]; then
        echo "Exiting the cutover process."
        exit 0
    fi
fi

# Display the next step
echo "Next Step: Step 5 - Validate the data from GCP and AWS"

# Step 5: Validate the data from GCP and AWS
echo "Step 5: Validate the data from GCP and AWS"
databases=$(run_gcp_sql "SELECT SCHEMA_NAME FROM information_schema.schemata WHERE SCHEMA_NAME NOT IN ('tmp','sys','performance_schema','percona','mysql','gds_pm','information_schema');")
databases=$(echo "$databases" | grep -vE "SCHEMA_NAME")

# Select 15 random tables from each database
declare -A aws_counts gcp_counts
for db in $databases; do
    tables=$(run_gcp_sql "SELECT TABLE_NAME FROM information_schema.tables WHERE table_schema='$db';")
    tables=$(echo "$tables" | grep -vE "TABLE_NAME" | shuf -n 15)
    for table in $tables; do
        aws_count=$(run_aws_sql "$aws_endpoint" "SELECT COUNT(*) FROM $db.$table;" | grep -v "COUNT(*)")
        gcp_count=$(run_gcp_sql "SELECT COUNT(*) FROM $db.$table;" | grep -v "COUNT(*)")
        aws_counts["$db.$table"]=$aws_count
        gcp_counts["$db.$table"]=$gcp_count
    done
done

# Display the counts
echo "Validation Results:"
echo "From AWS                  | From GCP"
for key in "${!aws_counts[@]}"; do
    echo "$key: ${aws_counts[$key]} Rows | $key: ${gcp_counts[$key]} Rows"
done

# Final message
echo "============================================================"
echo "Pre-cutover process completed. Please validate the results above."
echo "If everything looks good, proceed to the cutover [AWS TO GCP]."
echo "============================================================"

