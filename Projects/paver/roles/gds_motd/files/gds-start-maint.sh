#!/bin/sh
exec 2>&1
set -e


USER=$(logname)
DT=$(env TZ=UTC date +'%Y-%m-%d %H:%M')
DEFAULT_TICKET="NO_TICKET"

read   -p "GDS Ticket Number: [GDS-xxxx] " TICKET
TICKET="${TICKET:-$DEFAULT_TICKET}"
read -p "Description: [short description] " DESCRIPTION


if [ $TICKET = $DEFAULT_TICKET ]; then
	SESSION=$(env TZ=UTC date +'%Y%m%d-%H%M')
else
	SESSION=$TICKET
fi

echo "$DT - $USER - $TICKET - $DESCRIPTION - tmux: $USER-$SESSION" | sudo tee -a /etc/motd >> /dev/null

echo ""
echo "Does monitoring need to be suppressed? http::/groupon.nagios"
echo "motd updated. Please run maintenance using"
echo "tmux new -s $USER-$SESSION"
