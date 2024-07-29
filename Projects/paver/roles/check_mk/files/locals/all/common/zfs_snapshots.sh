#!/bin/sh
# zfs-snapshots-since.sh
# ----------------------
# zfs-snapshots-since.sh <dataset> <hours>
# TODO Creation times should be human readable
DATASET=${1:-}
HOURS=${2:-24}
TIME_NOW=`date +'%s'` || exit 1
TWENTYFOUR_HOUR=`bc -e "${HOURS}*60*60" -e quit` || exit 1
DELTA=`bc -e "$TIME_NOW"-"$TWENTYFOUR_HOUR" -e quit` || exit 1
TMPFILE=`mktemp` || exit 1
TMPFILE2=`mktemp` || exit 1
# list off snapshots
zfs list -p -r -t snapshot -o name,creation $DATASET > $TMPFILE || exit 1
# awk to only print snapshots we want
awk -v now="$TIME_NOW" -v twenty_four_h="$TWENTYFOUR_HOUR" \
    '$2 >= (now - twenty_four_h)' $TMPFILE > $TMPFILE2
# cleanup
awk -F '-' '{printf "%s-%s\n", $1, $2}' $TMPFILE2  | uniq -c
rm $TMPFILE
rm $TMPFILE2
