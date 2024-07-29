Role : GDS Carp Setup

Target : setup the carp cluster.

For the succesfull execution of this role are needed some requirements:

All the servers required to be defined in the gds-facts with the structured
variables for:

E.g. :
        "gds_prod_snc1_db001" : {
            "carp" : {
                "read-write" : {
                    "password" : "asdf2",
                    "ipv4" : "10.30.16.13/32",
                    "vlan" : 317 /* optional */
                },
                "read-only" : {
                    "password" : "qwer2",
                    "ipv4" : "10.30.16.14/32",
                    "vlan" : 317 /* optional */
                }
            }

The password can be easily generated ia the following command:

% cat /dev/random | hexdump -n 30| cut -d \  -f 2-| head -n 1 | tr -d " "


1 - At the paver repository at the path paver/host_vars/

Is needed a group of files that will contain the variables for the setup of
carp with the name hostnames .yml. E.g.:

gds-snc1-db004m1.snc1.yml ( master )
gds-snc1-db004s1.snc1.yml ( slave )

The variables are:

At the master:

carp_failover_weight : This the numeric value for the failover. Will be used just in the playbook of failover.
carp_master_weight : Initial weight that should be lower than the slave to setup the master.

At the slave:
carp_slave_weight : Initial weight that should be higher than the master.

E.g.:

carp_failover_weight: "20"
carp_master_weight: '50'

carp_slave_weight: '100'

Execution:
E.g.:

ansible-playbook -i inventory/gds-production site.yml --limit gds-snc1-db002m1.snc1,gds-snc1-db002s1.snc1 --start-at-task="GDS Carp Setup | FreeBSD | rc.conf | enable the master interface" -step

Execute till the task: "GDS Carp Setup | FreeBSD | rc.conf | enable the slave interface"

To stop the execution CTRL+C or the playbook will execute the following roles declared in the site.yml.

The role gds_carp_setup has to be part of the site.yml
