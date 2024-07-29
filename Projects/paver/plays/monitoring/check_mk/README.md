# Install and configure Check_MK for your database server

## MySQL

### Master

```% ansible-playbook plays/monitoring/check_mk/install-check-mk.yml -e target_host=gds-snc1-test-db001m1.snc1 -e 
db_type=mysql -e inst_type=master```

### Slave

```% ansible-playbook plays/monitoring/check_mk/install-check-mk.yml -e target_host=gds-snc1-test-db001s1.snc1 -e db_type=mysql -e inst_type=slave```


## PostgreSQL

### Master

```% ansible-playbook plays/monitoring/check_mk/install-check-mk.yml -e target_host=test-db5.snc1 -e db_type=postgresql -e inst_type=master```

### Slave

```% ansible-playbook plays/monitoring/check_mk/install-check-mk.yml -e target_host=test-db6.snc1 -e db_type=postgresql -e inst_type=slave```

# To configure only

Call above commands with --tags config_check_mk

# To install only

Call above commands with --tags install_check_mk
