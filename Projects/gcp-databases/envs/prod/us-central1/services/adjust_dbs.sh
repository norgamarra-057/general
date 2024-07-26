#!/bin/bash

# Function to modify variables.hcl file
modify_hcl_file() {
  local file="$1"
  # Read the file contents
  local content=$(cat "$file")

  # Replace replica_count
  content="${content//replica_count = 1/replica_count = 0}"

  # Replace db_tier
  content="${content//db_tier = \"db-custom-4-15360\"/db_tier = \"db-custom-8-30720\"}}"

  # Replace max_worker_processes
  content="${content//max_worker_processes = 16/max_worker_processes = 32}"

  # Additional replacements
  content="${content//max_logical_replication_workers = 12/max_logical_replication_workers = 24}"
  content="${content//max_wal_senders = 10/max_wal_senders = 25}"
  content="${content//max_replication_slots = 10/max_replication_slots = 20}"

  # Write the modified content back to the file
  echo "$content" > "$file"
}

# Loop through all subdirectories
for dir in */ ; do
  # Check if variables.hcl exists in the subdirectory
  if [[ -f "$dir/variables.hcl" ]]; then
    # Call the modification function for this file
    modify_hcl_file "$dir/variables.hcl"
    echo "Modified variables.hcl in $dir"
  fi
done

echo "All variables.hcl files processed!"
