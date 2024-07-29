Role : gds_carp

Target : load carp and set a entry in the loader(in case of restart the server will load carp).

Execution :
E.g.: 

ansible-playbook -i inventory/gds-production site.yml --limit gds-snc1-db002z1.snc1 --start-at-task="GDS Carp Load | variable check" -step

Execute till the task : "GDS Carp Load | FreeBSD | load carp"

To stop the execution CTRL+C or the playbook will execute the following roles declared in the site.yml.

The role gds_carp has to be part of the site.yml
