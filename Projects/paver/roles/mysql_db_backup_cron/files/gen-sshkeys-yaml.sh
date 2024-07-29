#!/bin/sh --

# Script takes a path to a public and its private SSH key and produces
# the correct YAML for use in the backup ssh key yaml variable file.
#
# This script assumes it is being used in a way similar to the
# following:
#
# 0) ansible-playbook --ask-vault-pass -i inventory/database-production delorean-database-backups.yml
# 1) ansible-vault decrypt roles/mysql_db_backup_cron/vars/mysql_db_backup_keys_vault.yml
# 2) sh gen-sshkeys-yaml.sh roles/mysql_db_backup_cron/vars/mysql_db_backup_keys_vault.yml path/to/host.pub
# 3) ansible-vault encrypt roles/mysql_db_backup_cron/vars/mysql_db_backup_keys_vault.yml


if [ $# -lt 2 ]; then
    /usr/bin/printf "Usage: %s <yaml_file> <pub_or_priv_ssh_key> [...]\n" "$0"
    exit 64
fi

DATE=`/bin/date -u "+%Y-%m-%d_%H:%M:%S"`

OUTFILE=$1
shift

if [ "${OUTFILE}" = "-" ]; then
    OUTFILE="/dev/stdout"
else
    if [ -e "${OUTFILE}" -a ! -f "${OUTFILE}" ]; then
	/usr/bin/printf "ERROR: Output file (%s) exists but is not a file\n" "${OUTFILE}"
	exit 66
    elif [ ! -e "${OUTFILE}" ]; then
	# Semi-securely spew some default content
	umask 0077
	/usr/bin/printf "---\nmysql_db_backup_keys: {}\n" >> "${OUTFILE}"
    fi

    if [ ! -w "${OUTFILE}" -o ! -f "${OUTFILE}" ]; then
	/usr/bin/printf "ERROR: Unable to write to file %s\n" "${OUTFILE}"
	exit 77
    fi
fi


# Simple sanity check to make sure we're not nuking an encrypted YAML file
FIRST_LINE=`/usr/bin/head -1 "${OUTFILE}" | /usr/bin/grep '^---'`
if [ "x${FIRST_LINE}" != "x---" ]; then
    /usr/bin/printf "ERROR: Expecting YAML file target. Refusing to write to non-YAML file %s\n" "${OUTFILE}"
    exit 65
fi

# If we're bootstrapping a new file, the file must have been created
# with an empty hash. Blindly appending content to this fill will
# create a YAML file with an invalid syntax. Grab bazooka and apply
# with naive force.
/usr/bin/sed -i'' -e 's#^mysql_db_backup_keys: {}$#mysql_db_backup_keys:#' "${OUTFILE}"

KEYS_APPENDED=0

# Unique'ify the input to prevent duplicates
for f in `/usr/bin/find $* -type f | /usr/bin/sed -e 's#.pub$##g' | /usr/bin/sort | /usr/bin/uniq`; do
    KEYDIR=`dirname ${f}`
    SSH_PRIV_KEY=`basename -s .pub ${f}`
    SSH_PUB_KEY="${SSH_PRIV_KEY}.pub"

    # Make sure both the public and private keys exist
    if [ ! -r "${KEYDIR}/${SSH_PUB_KEY}" ]; then
	/usr/bin/printf "Unable to read SSH public key: %s\n" "${KEYDIR}/${SSH_PUB_KEY}"
	exit 1
    fi

    if [ ! -r "${KEYDIR}/${SSH_PRIV_KEY}" ]; then
	/usr/bin/printf "Unable to read SSH private key: %s\n" "${KEYDIR}/${SSH_PRIV_KEY}"
	exit 1
    fi

    HOST="${SSH_PRIV_KEY}"

    # If host already exists, continue to the next host in the
    # list. ...just in case people needed a reminder that sh(1) is
    # scary and that YAML isn't the most manipulable format when
    # scripting.
    if [ "x  ${HOST}:" = "x`/usr/bin/grep \"^  ${HOST}:\" \"${OUTFILE}\"`" ]; then
	continue
    fi

    /usr/bin/printf "  %s:\n" "${HOST}" >> "${OUTFILE}"
    /usr/bin/printf "    created_at: %s\n" "${DATE}" >> "${OUTFILE}"
    /usr/bin/printf "    created_by: %s\n" "${USER}" >> "${OUTFILE}"
    /usr/bin/printf "    public_ssh_key: %s\n" "`cat ${KEYDIR}/${SSH_PUB_KEY}`" >> "${OUTFILE}"
    /usr/bin/printf "    private_ssh_key: |-\n" >> "${OUTFILE}"
    cat ${KEYDIR}/${SSH_PRIV_KEY} | sed -e 's#^#      #g' >> "${OUTFILE}"
    KEYS_APPENDED=`expr ${KEYS_APPENDED} + 1`
done

# Signal to caller that we changed something
/usr/bin/printf "keys_appended=%d\n" "${KEYS_APPENDED}"
exit 0
