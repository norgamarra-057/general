#!/bin/sh
#
# Install this file:
# cd .git/hooks && ln -sf ../../.git-hooks-pre-commit.sh pre-commit

exec 1>&2

# Don't commit password files
PASSFILES=`git status -s | grep \.pass$`
if [ -n "${PASSFILES}" ]; then
    printf "Do NOT commit a .pass file (%s)\n" "${PASSFILES}"
    exit 1
fi

# Don't commit files over 1MB to this repository
for f in `git status -s -uno | grep -v '^D' | awk '{print $2}'`; do
    if [ -f "${f}" ]; then
        if [ "0`stat -f "%z" ${f}`" -gt "1048576" ]; then
            printf "Do NOT add files over 1MB to this repository (%s)\n" "${f}"
            exit 1
        fi
    fi
done

# Don't commit unencrypted Ansible vault files to this repository
for f in `git status -s | grep vault.yml$ | awk '{print $2}'`; do
    if [ `head -1 ${f}` != '$ANSIBLE_VAULT;1.1;AES256' ]; then
        printf "Unencrypted Ansible vault files are prohibitted from being committed to the repository (%s)\n" "${f}"
        exit 1
    fi
done

# Don't accidentally introduce ansible_ssh_user in to an inventory file
TAINTED_INVENTORY_FILES=`git status -s | awk '{print $2}' | grep -e 'inventory/' | xargs grep ansible_ssh_user= | egrep -v '^[^:]+:#'`
if [ -n "${TAINTED_INVENTORY_FILES}" ]; then
    printf "Don't commit uncommented ansible_ssh_user entries in inventory/ files\n\n\t%s\n" "${TAINTED_INVENTORY_FILES}"
    exit 1
fi
