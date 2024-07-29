#!/usr/bin/env sh

error() {
    errcode=$1
    shift
    echo " [!] $@"
    exit $errcode
}

# Set up or update dependencies of this repository
ansible-galaxy --help >/dev/null 2>&1
if [ $? -ne 0 ]; then
    error 1 "Ansible galaxy was not found. Exiting."
fi

# Install or update roles
ansible-galaxy install -f -n -r requirements.yml

# Update inventory
# Coming soon...
