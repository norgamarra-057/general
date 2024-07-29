Role : GDS Postgresql

Target : setup a postgresql instance

For the succesfull execution of this role are needed some requirements:

1 - At the paver repository at the path paver/host_vars/

Is needed a file that will contain the variables for the setup of postgresql with the name hostname.yml. E.g. : gds-snc1-db002s1.snc1.yml.

The variables are  :

gds_cluster: name of the cluster that will be created. This will define the structure for part of the data directory and the runit service.
postgresql_port_major: major version of the ports that will be installed.

E.g.:

gds_cluster: gds_prod_snc1_db002
postgresql_port_major: '93'


The role gds_postgresql has to be part of the site.yml. Also we declare the variable cluster name.

E.g :
- hosts: gds-snc1-stg-db002s1.snc1
  become: yes
  roles:
    - { role: gds_postgresql, instance_name: ${FILL ME IN} }

Execution:
E.g.:

ansible-playbook -i inventory/gds-production site.yml --limit gds-snc1-db002s1.snc --start-at-task="GDS PostgreSQL Cluster | variable check" -step

Execute till the task : "PostgreSQL | runit"

To stop the execution CTRL+C or the playbook will execute the following roles declared in the site.yml.

