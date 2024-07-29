Role : Monitord Agent

Target : setup the agent for the monitord and install the monitoring scripts for freebsd.

For the succesfull setup of the monitoring, is needed to setup the roller host classes of the hosts with the proper configuration.
For more details please access: https://wiki.groupondev.com/Monitord_Agent

The role monitord_agent has to be part of the site.yml. 

Execution :
E.g.: 

ansible-playbook -i inventory/gds-production site.yml --limit gds-snc1-db002s1.snc1 --start-at-task="GMONITORD | FreeBSD | Create group" -step

Execute till the task : "FreeBSD | runit | monitord cron"

To stop the execution CTRL+C or the playbook will execute the following roles declared in the site.yml.
