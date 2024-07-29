#!/usr/bin/env bash

echo "make sure you add a mysql / postgres user:"
echo "  GRANT SELECT, PROCESS, SHOW VIEW, REPLICATION CLIENT ON *.* TO 'vcmonitor'@'127.0.0.1' IDENTIFIED BY 'VCece1e5c7a3aaa';"
echo "OR"
echo "  CREATE ROLE vcmonitor NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN PASSWORD 'VCece1e5c7a3aaa';"
echo ""

CONFFILE="/usr/local/etc/vividcortex/vc-agent-007.conf"
CONFFILE_OLD="/usr/local/etc/vividcortex/vc-agent-007.conf.old"
CMD_STR="./port-to-ip.sh $1"
INFO=$(exec $CMD_STR | head -n1)
FULLSTRING="{
	\"use-drv-mysql\": false,
	\"use-drv-pgsql\": false,
	\"drv-manual-host-uri\" : \"$(echo -ne "$INFO" | awk '{printf $7}')=$(echo -ne "$INFO" | awk '{printf $5}')://vcmonitor:VCece1e5c7a3aaa@127.0.0.1:$(echo -ne "$INFO" | awk '{printf $2}')\"
}"
export PARTSTRING=",$(echo -ne "$INFO" | awk '{printf $7}')=$(echo -ne "$INFO" | awk '{printf $5}')://vcmonitor:VCece1e5c7a3aaa@127.0.0.1:$(echo -ne "$INFO" | awk '{printf $2}')\""


if [ -f $CONFFILE ]
  then
    echo "overwriting file $CONFFILE"
    mv $CONFFILE $CONFFILE_OLD
    cat $CONFFILE_OLD | awk '/\"$/ {printf; print ENVIRON["PARTSTRING"]; next}1' > $CONFFILE
  else
    echo "writing new file $CONFFILE"
    echo "$FULLSTRING" > $CONFFILE
fi

sleep 0.5
/usr/local/bin/vc-agent-007  -config-file="/usr/local/etc/vividcortex/global.conf,/usr/local/etc/vividcortex/vc-agent-007.conf"
