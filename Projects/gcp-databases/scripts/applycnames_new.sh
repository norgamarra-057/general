#!/bin/bash

# Change directory to the cnames folder
cd ../envs/stable/us-central1/cnames/

# List the available folders
echo "Available folders:"
ls -l

# Ask for the folder name
read -p "Enter the folder name: " folder_name

# Change directory to the selected folder
cd "$folder_name" || { echo "Folder not found"; exit 1; }

# Go back to the scripts folder
cd -
cd scripts || { echo "Script path not found"; exit 1; }
cd ..

# Run the plan command
terrabase plan envs/stable/us-central1/cnames/"$folder_name"

# Prompt for confirmation before applying
read -p "Verify the plan and press enter to apply"

# Run the apply command
terrabase apply envs/stable/us-central1/cnames/"$folder_name" > "${folder_name}_apply_output_file.txt"


echo "Apply completed successfully. Apply output saved to: ${folder_name}_apply_output_file.txt"

