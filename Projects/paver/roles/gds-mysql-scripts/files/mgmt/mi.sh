#!/usr/bin/env bash

rootdir="/root"
conffile="my.cnf"
confpath="${rootdir}/.${conffile}"

function err {
    errcode=$1
    shift
    msg="$@"
    echo "$msg"
    exit $errcode
}

function lookup_instance_name {
    path="$1"
    ls -la "${path}" | awk -F'->' '{ print $NF}' |  awk -F${conffile}- '{print $NF}'
}

function get_current {
    stat "${confpath}" >/dev/null 2>&1
    [ $? -eq 0 ] && lookup_instance_name "${confpath}"
}

function set_current {
    [ -n "$1" ] && instance="$1" || err 2 "instance name required"
    instancepath="${confpath}-${instance}"

    # Check if instance exist
    [ -f "${instancepath}" ] || err 3 "no such instance"

    # Unlink old, if set
    [ -f "${confpath}" ] && unset_current

    # Set instance pointer
    ln -sf "${instancepath}" "${confpath}"
    [ $? -ne 0 ] && err 4 "failed to set instance ${instance}"

    return 0
}

function unset_current {
    # Unlink current symlink
    [ -f "${confpath}" ] && rm -f "${confpath}"
}

function list_instances {
    # See if any instance is set
    current=$(get_current)
    # Look up instances with globbing"
    files=$(ls $confpath-* 2>/dev/null)
    # Display TM
    for f in ${files}; do
    instance=$(lookup_instance_name ${f})
    if [ "${instance}" == "${current}" ]; then
        echo "* ${instance}"
    else
        echo "  ${instance}"
    fi
    done
}

function usage() {
    echo "Usage: -l (list instances)"
    echo "       -s instance_name (set instance as current)"
    echo "       -u (unset the current instance)"
    echo "       -g (get current instance name)"
    exit 1
}

while getopts "glus:h" opt; do
    case $opt in
        l)
            list_instances
            ;;
        u)
            unset_current
            ;;
        s)
            set_current $OPTARG
            ;;
        g)
            get_current
            ;;
        h)
            usage;;
    esac
done
