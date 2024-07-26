: <<'end_long_comment'
export R_HOSTS=hosts/discussion-service-raas?.snc1*
export R_ALERT=raas-alerts@groupon.com
export R_CLUSTER=us.raas-cs_discussion-prod.grpn
export R_MONITORING_CLUSTER=discussion_prod
end_long_comment

SUPPORT_CREW="pablo ksatyamurthy kbandaru c_vmoule c_oluzon c_yzubkov c_ldroin"

( [ -z "$R_HOSTS" ] || [ -z "$R_ALERT" ] || [ -z "$R_CLUSTER" ] ) && echo "no params received" && exit 1

LATEST_HOSTCLASS=$(grep 'hostclass: redislabs5-' hosts/raas-* -h | sort -u|tail -n1|awk '{print $2}')
[ -z "$LATEST_HOSTCLASS" ] && echo "cannot find latest hostclass" && exit 1

./bin/yawk -i 'd.os_config.start_with?("centos66") or d.os_config.start_with?("centos7") or raise("invalid os_config")' $R_HOSTS || exit 2
grep 127.0.0.1 $R_HOSTS && echo "found a 127.0.0.1!" exit 3
./bin/yawk -i '["mem","ntp","cpu","swap","iostat","disk_space","ssh"].each{|m| d.monitors.delete(m)}' $R_HOSTS || exit 4
./bin/yawk -i "r='raas-alerts@groupon.com';x={r=>{'notify_on'=> ['ok', 'warning', 'critical', 'unknown']}}; d.notify.delete(r); d.notify.push(x); d.notify_host.delete(r); d.notify_host.push(r)" $R_HOSTS || exit 5
./bin/yawk -i "r='$R_ALERT';x={r=>{'notify_on'=> ['ok', 'warning', 'critical', 'unknown']}}; d.notify.delete(r); d.notify.push(x); d.notify_host.delete(r); d.notify_host.push(r)" $R_HOSTS || exit 6
# https://confluence.groupondev.com/display/PRODOPS/Foreman+support+for+non-foreman+users
# https://github.groupondev.com/prod-tools/ops-tools/pull/310
./bin/yawk -i 'd.params.delete("foreman")' $R_HOSTS || exit 7
./bin/yawk -i "d.params['redislabs']||={};d.params['redislabs']['cluster_name']='$R_CLUSTER'" $R_HOSTS || exit 8
./bin/yawk -i "d.monitors.each{|k,v| v['runbook_url']='https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-net_eth' if k.start_with?('net_eth')}" $R_HOSTS || exit 9

for u in $SUPPORT_CREW; do ./bin/user_access grant -c -s $u $R_HOSTS; done

./bin/set_hostclass $LATEST_HOSTCLASS $R_HOSTS
./bin/yawk -i "d.params.monitoring_cluster='$R_MONITORING_CLUSTER'" $R_HOSTS
