#!/bin/bash

# Function to modify variables.hcl file
modify_hcl_file() {
  local file="$1"
  # Read the file contents
  local content=$(cat "$file")

  # Replace trailing characters after max_replication_slots = 10
  content="${content%max_replication_slots = 20*}max_replication_slots = 20"

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
