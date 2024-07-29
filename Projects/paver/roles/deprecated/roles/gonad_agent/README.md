Role : Gonad Agent

Target : setup the agent for Circonus monitoring and the go scripts in go.

Will be installed the following scripts :

Check utilization vmstat : info about the vmstat for freebsd.
Check utilization top : info about the top command regarding processes.
Check utilization ps : info about the processes and the percentage of cpu used.
Check saturation top : info about the load on the server and the uptime of the server.
Check postgres replication lag : info about the replication lag based on rows inserted in the master and replicated.
Check ipmi entries : info about the ipmi entries generated in case of hardware issues.

For the succesfull execution of this role are needed some requirements : 

1 - At the paver repository at the path paver/host_vars/

Is needed a file that will contain the variables for the setup of postgresql with the name hostname.yml. E.g. : gds-snc1-db002s1.snc1.yml.

The variables are  :

gonad_trap_1 : http trap that will receive the data from one of the go scripts.

E.g.: 

gonad_trap_1 : https://10.20.131.188:43191/module/httptrap/933d8b96-40db-4009-9f43-7d03e35f6a3d/mys3cr3t_trap_1

After in Circonus is needed to add the metrics for each check and proceed with graphs,histogram or thresholds.


The role gonad_agent has to be part of the site.yml. 

Execution :
E.g.: 

ansible-playbook -i inventory/gds-production site.yml --limit gds-snc1-db002s1.snc1 --start-at-task="GONAD | create group" -step

Execute till the task : "GONAD | FreeBSD | runit | monitord cron"

To stop the execution CTRL+C or the playbook will execute the following roles declared in the site.yml.
