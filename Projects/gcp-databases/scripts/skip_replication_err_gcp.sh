#!/bin/bash

# Prompt for the MySQL host
read -p "Enter the MySQL host: " mysql_host

# Set the log file
log_file="replication_errors.log"

# Calculate the end time (15 minutes from now)
end_time=$((SECONDS + 900))

# Loop until 15 minutes have passed
while [ $SECONDS -lt $end_time ]; do
    # Run the show slave status command and parse the output
    replication_status=$(mysql --defaults-file=~/.my.cnf -h "$mysql_host" -e "SHOW SLAVE STATUS \G")

    # Check if Slave_SQL_Running is 'No'
    if echo "$replication_status" | grep -q "Slave_SQL_Running: No"; then
        # Extract the Last_SQL_Error details
        last_sql_error=$(echo "$replication_status" | grep -A 1 "Last_SQL_Error:")

        # Extract the log file and position
        if [[ $last_sql_error =~ mysql-bin-changelog\.[0-9]+ ]]; then
            log_file_name=$(echo "$last_sql_error" | grep -oP 'mysql-bin-changelog\.[0-9]+')
            log_position=$(echo "$last_sql_error" | grep -oP 'end_log_pos \K[0-9]+')

            # Log the error details
            echo "Error in replication at log file: $log_file_name, position: $log_position" >> "$log_file"
            echo "Running .mysql.skipReplicationError;" >> "$log_file"

            # Call the procedure to skip the replication error
            mysql --defaults-file=~/.my.cnf -h "$mysql_host" -e "CALL mysql.skipReplicationError;"

            # Log the action taken
            echo "$(date): Executed skipReplicationError procedure" >> "$log_file"
        fi
    fi

    # Wait for 3 seconds before checking again
    sleep 3
done

echo "Replication monitoring completed. Check the log file at $log_file for details."
