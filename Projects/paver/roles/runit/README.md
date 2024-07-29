Role : Runit

Target : install and setup of Runit.

Execution :
E.g.: 

ansible-playbook -i inventory/gds-production site.yml --limit gds-snc1-db002z1.lup1 --start-at-task="runit | FreeBSD | package" -step

Execute till the task : "runit | FreeBSD | Set path"

To stop the execution CTRL+C or the playbook will execute the following roles declared in the site.yml.

The role runit has to be part of the site.yml