#!/bin/bash

# Change directory to the desired location
cd envs/stable/us-central1/cnames/

# Get the list of folders
folders=$(ls)

# List the folders
echo "Folders:"
echo "$folders"

# Select a folder
echo "Select a folder:"
select folder in $folders; do
    if [ -n "$folder" ]; then
        # Run the plan command
        cd $folder
        terrabase plan envs/stable/us-central1/cnames/$folder
        
        # Verify and apply changes
        read -p "Verify the plan. Do you want to apply these changes? (y/n) " answer
        if [ "$answer" == "y" ]; then
            terrabase apply envs/stable/us-central1/cnames/$folder
        else
            echo "Apply cancelled."
        fi
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

