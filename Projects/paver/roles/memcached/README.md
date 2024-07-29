Role : pgbouncer

Target : Install pgbouncer.

Execution :
E.g.: 

ansible-playbook -i inventory/gds-production site.yml --limit gds-snc1-db002z1.snc1 --start-at-task="GDS PgBouncer Cluster | variable check" -step

Execute till the task : "PostgreSQL Server | FreeBSD | pgbouncer"

To stop the execution CTRL+C or the playbook will execute the following roles declared in the site.yml.

The role gds_carp has to be part of the site.yml
