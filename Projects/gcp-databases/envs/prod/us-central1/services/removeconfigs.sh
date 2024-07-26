#!/bin/bash

# Define the lines to remove
lines_to_remove=(
  "max_connections = 2669"
  "autovacuum_analyze_scale_factor = 0.01"
  "autovacuum_max_workers = 10"
  "default_statistics_target = 1000"
  "log_temp_files = 0"
  "work_mem = \"22999\""
)

# Function to remove lines from a file
remove_lines_from_file() {
  local file="$1"
  for line in "${lines_to_remove[@]}"; do
    sed -i.bak "/$line/d" "$file"
  done
}

# Export the function and lines array to be used in find -exec
export -f remove_lines_from_file
export lines_to_remove

# Find all variables.hcl files in directories starting with 'pg' and remove specified lines
find . -type d -name "pg*" -exec find {} -type f -name "variables.hcl" \; | while read -r file; do
  remove_lines_from_file "$file"
done

# Optionally, remove backup files created by sed
find . -type f -name "variables.hcl.bak" -delete

