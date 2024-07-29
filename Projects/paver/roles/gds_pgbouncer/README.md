Role : GDS PgBouncer

Target : setup a PgBouncer instance that could be in the transactional, session or statement mode.

For the succesfull execution of this role are needed some requirements : 


The role gds_pgbouncer has to be part of the site.yml. Also is needed to declare the following variables : 
pgbouncer_mode: The mode that Pgbouncer will interact with the requests. The available modes are session, transactional or statement.
pgbouncer_port: the port that pgbouncer will be open for connections. This port has to be free.

E.g :
- hosts: gds-snc1-db002s1.snc1
  become: yes
  roles:
    - { role: gds_pgbouncer, pgbouncer_mode: session, pgbouncer_port: 5433 }

Execution :
E.g.: 

ansible-playbook -i inventory/gds-production site.yml --limit gds-snc1-db002s1.snc1 --start-at-task="GDS pgbouncer | default value check" -step

Execute till the task : "FreeBSD | pgbouncer | auth job cron"

To stop the execution CTRL+C or the playbook will execute the following roles declared in the site.yml.

