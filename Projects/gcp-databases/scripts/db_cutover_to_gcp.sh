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
    mysql -h "$endpoint" -u $db_user -p"$db_password" -e "$sql"
}

# Function to run SQL commands on GCP
run_gcp_sql() {
    local sql="$1"
    echo "Running SQL on GCP: $sql"
    mysql -h $gcp_ip -u $db_user -p"$db_password" -e "$sql"
}

# Read MySQL credentials from .my.cnf
read_mysql_credentials

# Prompt for AWS endpoint and GCP IP
read -p "Enter the AWS endpoint: " aws_endpoint
read -p "Enter the GCP IP: " gcp_ip

# Extract the base name for the log file from the AWS endpoint
base_name=$(echo "$aws_endpoint" | cut -d'.' -f1)
log_file="${base_name}.cutover.log"

# Redirect all output to the log file
exec > >(tee -i "$log_file") 2>&1

# Display cutover process steps
echo "============================================================"
echo "Cutover process initiated. Below are the steps involved:"
echo "============================================================"
echo "1. Locking the users in AWS instance DB Instance"
echo "2. Kill existing connections on AWS Instance after account lock"
echo "3. Apply the DNS changes"
echo "4. Confirm AWS DB cluster status"
echo "5. Promote the replica in GCP"
echo "6. Un-locking the users in GCP instance DB Instance"
echo "7. Locking the users in AWS instance DB Instance again"
echo "8. Validate user connections on GCP"
echo "9. Validate the reverse replication is working fine in AWS"
echo "10. Unlock the accounts on eu-west-1 AWS if cross-site region replication is enabled"

# Display the next step
echo "Next Step: Step 1 - Locking the users in AWS instance DB Instance"

# Step 1: Locking the users in AWS instance DB Instance
echo "Step 1: Locking the users in AWS instance DB Instance"
lock_users_sql="SELECT CONCAT('ALTER USER ''', user, '''@''', host, ''' ACCOUNT LOCK ;')  FROM mysql.user  WHERE user NOT IN ('event_scheduler','rdsadmin','system user','replication','gds_admin','checkmk_mon','pmm','pmm_mysql','mysql.sys','proxysql','rdsrepladmin');"
lock_users_commands=$(run_aws_sql "$aws_endpoint" "$lock_users_sql")

echo "List of alter commands to lock users:"
echo "$lock_users_commands"

read -p "Do you want to proceed with locking the users? (yes/no): " proceed_lock
if [ "$proceed_lock" == "yes" ]; then
    echo "Locking users..."
    while IFS= read -r line; do
        run_aws_sql "$aws_endpoint" "$line"
    done <<< "$lock_users_commands"
    echo "Users locked."

    echo "Validating locked users:"
    validate_locked_sql="SELECT user FROM mysql.user WHERE account_locked='Y';"
    run_aws_sql "$aws_endpoint" "$validate_locked_sql"

    validate_unlocked_sql="SELECT user FROM mysql.user WHERE account_locked='N';"
    run_aws_sql "$aws_endpoint" "$validate_unlocked_sql"
else
    echo "Skipping user lock step."
fi

# Display the next step
echo "Next Step: Step 2 - Kill existing connections on AWS Instance after account lock"

# Step 2: Kill existing connections on AWS Instance after account lock
echo "Step 2: Kill existing connections on AWS Instance after account lock"
kill_connections_sql="SELECT CONCAT('KILL ', id, ';') FROM information_schema.processlist WHERE user NOT IN ('event_scheduler','rdsadmin','system user','replication','gds_admin','checkmk_mon','pmm','pmm_mysql','mysql.sys','proxysql','rdsrepladmin');"
kill_connections_commands=$(run_aws_sql "$aws_endpoint" "$kill_connections_sql")

echo "List of kill commands to terminate connections:"
echo "$kill_connections_commands"

read -p "Do you want to proceed with killing the connections? (yes/no): " proceed_kill
if [ "$proceed_kill" == "yes" ]; then
    echo "Killing connections..."
    while IFS= read -r line; do
        run_aws_sql "$aws_endpoint" "$line"
    done <<< "$kill_connections_commands"
    echo "Connections terminated."
else
    echo "Skipping kill connections step."
fi

# Display the next step
echo "Next Step: Step 3 - Apply the DNS changes"

# Step 3: Apply the DNS changes
echo "Step 3: Apply the DNS changes"
echo "Please apply the DNS changes as required and then proceed."

read -p "Have the DNS changes been applied? (yes/no): " dns_applied
if [ "$dns_applied" != "yes" ]; then
    echo "Please apply the DNS changes and then rerun the script."
    exit 0
fi

# Display the next step
echo "Next Step: Step 4 - Confirm AWS DB cluster status"

# Step 4: Confirm AWS DB cluster status
echo "Step 4: Confirm the AWS DB cluster status"
read -p "Is the AWS DB cluster in the desired status to proceed? (yes/no): " aws_db_status
if [ "$aws_db_status" != "yes" ]; then
    echo "Please ensure the AWS DB cluster is in the desired status and then rerun the script."
    exit 0
fi

# Wait for user confirmation to proceed
read -p "Do you want to proceed with promoting the replica? (yes/no): " proceed_promote
if [ "$proceed_promote" != "yes" ]; then
    echo "Exiting the cutover process."
    exit 0
fi

echo "Next Step: Step 5 - Promote the replica in GCP"

# Step 5: Promote the replica in GCP
echo "Step 5: Promote the replica in GCP"
read -p "Enter the GCP instance name: " GCP_INSTANCE
read -p "Enter the environment (prod/stable): " ENVIRONMENT

if [ "$ENVIRONMENT" == "prod" ]; then
    PROMOTE_COMMAND="gcloud --impersonate-service-account=grpn-sa-terraform-gds@prj-grp-central-sa-prod-0b25.iam.gserviceaccount.com sql instances promote-replica $GCP_INSTANCE"
elif [ "$ENVIRONMENT" == "stable" ]; then
    PROMOTE_COMMAND="gcloud --impersonate-service-account=grpn-sa-terraform-gds@prj-grp-central-sa-stable-66eb.iam.gserviceaccount.com sql instances promote-replica $GCP_INSTANCE"
else
    echo "Invalid environment specified."
    exit 1
fi

echo "Promoting the replica..."
$PROMOTE_COMMAND

read -p "Do you want to proceed with the next steps? (yes/no): " proceed_promote
if [ "$proceed_promote" != "yes" ]; then
    echo "Exiting the cutover process."
    exit 0
fi

echo "Next Step: Step 6 - Un-locking the users in GCP instance DB Instance"

# Step 6: Un-locking the users in GCP instance DB Instance
echo "Step 6: Un-locking the users in GCP instance DB Instance"

unlock_users_sql="SELECT CONCAT('ALTER USER ''', user, '''@''', host, ''' ACCOUNT UNLOCK ;')  FROM mysql.user  WHERE user NOT IN ('event_scheduler','rdsadmin','system user','replication','gds_admin','checkmk_mon','pmm','pmm_mysql','mysql.sys','proxysql','rdsrepladmin','cloudiamgroup','cloudsqlreplica','cloudsqlsuperuser','root','cloudsqlexport','cloudsqlimport','cloudsqlobservabilityadmin','cloudsqloneshot','cloudsqlapplier','mysql.infoschema','mysql.session');"
unlock_users_commands=$(run_gcp_sql "$unlock_users_sql")

echo "List of alter commands to unlock users:"
echo "$unlock_users_commands"

read -p "Do you want to proceed with unlocking the users? (yes/no): " proceed_unlock
if [ "$proceed_unlock" == "yes" ]; then
    echo "Unlocking users..."
    while IFS= read -r line; do
        run_gcp_sql "$line"
    done <<< "$unlock_users_commands"
    echo "Users unlocked."

    echo "Validating unlocked users:"
    validate_locked_sql="SELECT user FROM mysql.user WHERE account_locked='Y';"
    locked_users=$(run_gcp_sql "$validate_locked_sql" | grep -v "user")
    echo "Locked users:"
    echo "$locked_users"

    validate_unlocked_sql="SELECT user FROM mysql.user WHERE account_locked='N';"
    unlocked_users=$(run_gcp_sql "$validate_unlocked_sql" | grep -v "user")
    echo "Unlocked users:"
    echo "$unlocked_users"
else
    echo "Skipping user unlock step."
fi

echo "Next Step: Step 7 - Locking the users in AWS instance DB Instance again"

# Step 7: Locking the users in AWS instance DB Instance again
echo "Step 7: Locking the users in AWS instance DB Instance again"

lock_users_sql="SELECT CONCAT('ALTER USER ''', user, '''@''', host, ''' ACCOUNT LOCK ;')  FROM mysql.user  WHERE user NOT IN ('event_scheduler','rdsadmin','system user','replication','gds_admin','checkmk_mon','pmm','pmm_mysql','mysql.sys','proxysql','rdsrepladmin');"
lock_users_commands=$(run_aws_sql "$aws_endpoint" "$lock_users_sql")

echo "List of alter commands to lock users:"
echo "$lock_users_commands"

read -p "Do you want to proceed with locking the users? (yes/no): " proceed_lock
if [ "$proceed_lock" == "yes" ]; then
    echo "Locking users..."
    while IFS= read -r line; do
        run_aws_sql "$aws_endpoint" "$line"
    done <<< "$lock_users_commands"
    echo "Users locked."

    echo "Validating locked users:"
    validate_locked_sql="SELECT user FROM mysql.user WHERE account_locked='Y';"
    run_aws_sql "$aws_endpoint" "$validate_locked_sql"

    validate_unlocked_sql="SELECT user FROM mysql.user WHERE account_locked='N';"
    run_aws_sql "$aws_endpoint" "$validate_unlocked_sql"
else
    echo "Skipping user lock step."
fi

echo "Next Step: Step 8 - Validate user connections on GCP"

# Step 8: Validate user connections on GCP
echo "Step 8: Validate user connections on GCP"

validate_connections_sql="SELECT user, host FROM information_schema.processlist WHERE user NOT IN ('event_scheduler','rdsadmin','system user','replication','gds_admin','checkmk_mon','pmm','pmm_mysql','mysql.sys','proxysql','rdsrepladmin','cloudiamgroup','cloudsqlreplica','cloudsqlsuperuser','root','cloudsqlexport','cloudsqlimport','cloudsqlobservabilityadmin','cloudsqloneshot','cloudsqlapplier','mysql.infoschema','mysql.session');"
run_gcp_sql "$validate_connections_sql"

# Additional steps if required
read -p "Do you want to proceed with additional steps? (yes/no): " proceed_additional
if [ "$proceed_additional" != "yes" ]; then
    echo "Skipping additional steps."
    exit 0
fi

echo "Next Step: Step 9 - Validate the reverse replication is working fine in AWS"

# Step 9: Validate the reverse replication is working fine in AWS
echo "Step 9: Validate the reverse replication is working fine in AWS"

validate_replication_sql="SHOW SLAVE STATUS\G;"
run_aws_sql "$aws_endpoint" "$validate_replication_sql"

# Additional validation steps if required
read -p "Do you want to proceed with additional validation steps? (yes/no): " proceed_validation
if [ "$proceed_validation" != "yes" ]; then
    echo "Skipping additional validation steps."
    exit 0
fi

echo "Next Step: Step 10 - Unlock the accounts on eu-west-1 AWS if cross-site region replication is enabled"

# Step 13: Unlock the accounts on eu-west-1 AWS if cross-site region replication is enabled
echo "Step 13: Unlock the accounts on eu-west-1 AWS if cross-site region replication is enabled"
read -p "Enter the eu-west-1 AWS endpoint: " eu_west_1_aws_endpoint

unlock_users_sql="SELECT CONCAT('ALTER USER ''', user, '''@''', host, ''' ACCOUNT LOCK ;')  FROM mysql.user  WHERE user NOT IN ('event_scheduler','rdsadmin','system user','replication','gds_admin','checkmk_mon','pmm','pmm_mysql','mysql.sys','proxysql','rdsrepladmin');"

unlock_users_commands=$(run_aws_sql "$eu_west_1_aws_endpoint" "$unlock_users_sql")

echo "List of alter commands to unlock users:"
echo "$unlock_users_commands"

read -p "Do you want to proceed with unlocking the users? (yes/no): " proceed_unlock
if [ "$proceed_unlock" == "yes" ]; then
    echo "Unlocking users..."
    while IFS= read -r line; do
        run_aws_sql "$eu_west_1_aws_endpoint" "$line"
    done <<< "$unlock_users_commands"
    echo "Users unlocked."

    echo "Validating unlocked users:"
    validate_locked_sql="select user from mysql.user where account_locked='Y';"
    run_aws_sql "$eu_west_1_aws_endpoint" "$validate_locked_sql"

    validate_unlocked_sql="select user from mysql.user where account_locked='N';"
    run_aws_sql "$eu_west_1_aws_endpoint" "$validate_unlocked_sql"
else
    echo "Skipping user unlock step."
fi

# Final log message
echo "Cutover process completed."

