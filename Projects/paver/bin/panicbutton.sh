#!/usr/bin/env bash

RIGHTNOW=$(date +"%Y_%m_%d_%H_%M_%S")

pt-stalk --cycles=1 --sleep=3 --variable=Connections --threshold=1 --iterations=3 --run-time=5 --dest=/root/panicbutton --disk-bytes-free=10M
dmesg > /root/panicbutton/$RIGHTNOW-dmesg
zpool status > /root/panicbutton/$RIGHTNOW-zpool_status
zpool list >> /root/panicbutton/$RIGHTNOW-zpool_status
swapctl -s all > /root/panicbutton/$RIGHTNOW-swap
pfctl -s all > /root/panicbutton/$RIGHTNOW-pfctl
mysql -e "call sys.gds_report_all;" > /root/panicbutton/gds_sys_report.out

