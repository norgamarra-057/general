# Creating a new mysql instance with switchover capabilities

## Creating cluster definition

Add the cluster's metadata for gds_instances group variables. This is is group_vars. If you would like to add an instance to gds-prod-db001{m,s,r,z}1.snc1, then add your instance definition to the following yaml.

```
group_vars/gds_snc1_prod_db001.yml
```

WARNING! FIXME(pboros@): currently only the yaml above is taken into account, that has to be fixed.

One example for a yaml defining a highly available instance is the following.

```
gds_instances:
  scamtracker_prod: # GDS-931
    type: mysql
    write_origin: snc1
    # Priority is a numeric value between 0 and 100, lower priority rules get
    # sorted first. No priority == priority 100.
    firewall_priority: 150
    unix_user: gds_uid60014
    nodes:
      - gds-snc1-prod-db001m1.snc1
      - gds-snc1-prod-db001s1.snc1
    master_carp_interface: vlan316
    slave_carp_interface: vlan317
    vhid: 34
    master_vip: 10.30.16.34
    slave_vips:
      - 10.30.17.34
    replication_ips:
      - 10.20.114.179 # gds-snc1-prod-db001m1.snc1
      - 10.20.114.31  # gds-snc1-prod-db001s1.snc1
    firewall_permitted_src_cidrs:
      - 10.20.131.214/32 # dbclustermon1.snc1
      - 10.22.64.77/32  #latam-scamtracker1.snc1
    dba_account_name: scamtracker_prod_dba
    dba_src_cidrs: 
      - 10.22.64.77/32  #latam-scamtracker1.snc1
    ports:
      mysqld: 20014

```

You probably don't need to add 

```
gds_instances:
```
at the top, because it's already created, you just have to add a new definition under it.

After this, you have to define the instances in site.yml.

```
- hosts: gds_snc1_prod_db001
  become: yes
  roles:
  - { role: gds_mysql,
      instance_name: scamtracker_prod,
      innodb_io_capacity_force: 1000,
      innodb_lru_scan_depth_force: 100,
      innodb_buffer_pool_size_mb_force: 1000,
      auto_increment_offset_force: 1 }

```

And add the manager role to the MHA manager of this instance:
```
- hosts: gds-admin01.snc1
  become: yes
  roles:
  - { role: gds_poudriere }
  - { role: gds_mha_manager,
      instance_name: scamtracker_prod }

```

Most likely your hosts will have more than one instance defined also the manager node is most likely manager for more than one instance.

```
% ansible-playbook -i inventory/gds-production site.yml --limit=gds-snc1-prod-db001m1.snc1 --start-at-task="GDS Percona Cluster | variable check"
```

After this, it should be up.

```
root@gds-snc1-prod-db001m1:/var/service # sv stat scamtracker_prod-gds_prod_snc1_db001-*/
run: scamtracker_prod-gds_prod_snc1_db001-mysql/: (pid 92685) 32s; run: log: (pid 92684) 32s
down: scamtracker_prod-gds_prod_snc1_db001-pt_heartbeat-percona/: 0s, normally up, want up; run: log: (pid 94215) 21s
run: scamtracker_prod-gds_prod_snc1_db001-slowlog_rotator/: (pid 94218) 21s; run: log: (pid 94216) 21s
```

FIXME(pboros@): Currently, you have to set read_only to 0 to fix pt-heartbeat initially.

```
root@gds-snc1-prod-db001m1:/var/service # mi.sh -l
  client_id_prod
  cs_tools_prod
  dynamic_pricing_prod
* espresso_prod
  getaways_search_prod
  getaways_security_prod
  glive_gia_prod
  glive_inventory_prod
  killbill_latam_prod
  killbill_prod
  mission_control_prod
  mydept_myapp_prod
  po_manager_prod
  pricing_s4_prod
  scamtracker_prod
root@gds-snc1-prod-db001m1:/var/service # mi.sh -s scamtracker_prod
root@gds-snc1-prod-db001m1:/var/service # mysql -e "set global read_only=0; select sleep(3); set global read_only=1;"
+----------+
| sleep(3) |
+----------+
|        0 |
+----------+
root@gds-snc1-prod-db001m1:/var/service # sv stat scamtracker_prod-gds_prod_snc1_db001-*/
run: scamtracker_prod-gds_prod_snc1_db001-mysql/: (pid 92685) 117s; run: log: (pid 92684) 117s
run: scamtracker_prod-gds_prod_snc1_db001-pt_heartbeat-percona/: (pid 3823) 9s; run: log: (pid 94215) 106s
run: scamtracker_prod-gds_prod_snc1_db001-slowlog_rotator/: (pid 94218) 106s; run: log: (pid 94216) 106s
```

Run the playbook on the slave as well:

```
% ansible-playbook -i inventory/gds-production site.yml --limit=gds-snc1-prod-db001s1.snc1 --start-at-task="GDS Percona Cluster | variable check"
```

Apply the same workaround to fix pt-heartbeat:

```
root@gds-snc1-prod-db001s1:/var/service # sv stat scamtracker_prod-gds_prod_snc1_db001-*/
run: scamtracker_prod-gds_prod_snc1_db001-mysql/: (pid 77091) 29s; run: log: (pid 77090) 29s
run: scamtracker_prod-gds_prod_snc1_db001-pt_heartbeat-percona/: (pid 80284) 0s; run: log: (pid 78619) 18s
run: scamtracker_prod-gds_prod_snc1_db001-slowlog_rotator/: (pid 78622) 18s; run: log: (pid 78620) 18s
root@gds-snc1-prod-db001s1:/var/service # mi.sh -l
  client_id_prod
  cs_tools_prod
  dynamic_pricing_prod
* espresso_prod
  getaways_search_prod
  getaways_security_prod
  glive_gia_prod
  glive_inventory_prod
  killbill_latam_prod
  killbill_prod
  mission_control_prod
  po_manager_prod
  pricing_s4_prod
  scamtracker_prod
root@gds-snc1-prod-db001s1:/var/service # mi.sh -s scamtracker_prod
root@gds-snc1-prod-db001s1:/var/service # mysql -e "set global read_only=0; select sleep(3); set global read_only=1;"
+----------+
| sleep(3) |
+----------+
|        0 |
+----------+
root@gds-snc1-prod-db001s1:/var/service # sv stat scamtracker_prod-gds_prod_snc1_db001-*/
run: scamtracker_prod-gds_prod_snc1_db001-mysql/: (pid 77091) 67s; run: log: (pid 77090) 67s
run: scamtracker_prod-gds_prod_snc1_db001-pt_heartbeat-percona/: (pid 83453) 6s; run: log: (pid 78619) 56s
run: scamtracker_prod-gds_prod_snc1_db001-slowlog_rotator/: (pid 78622) 56s; run: log: (pid 78620) 56s
```

Set up the MHA controller box:
```
% ansible-playbook -i inventory/gds-production site.yml --limit gds-admin01.snc1 --start-at-task="GDS MHA | manager | variable check"
```

After this, the cluster's configuration will be on the manager node:
```
17:45 c_pboros@gds-admin01 % sudo su - gds_mha
gds_mha@gds-admin01:~ % ls scamtracker_prod-mha.cnf 
scamtracker_prod-mha.cnf

```

Some time in the future, we will have a playbook to reload the firewall on a single host. This is not the case today. If you didn't run the full playbook so far, now you have to to reload the firewall rules.

```
% ansible-playbook -i inventory/gds-production site.yml --limit gds_snc1_prod_db001
```

The firewall rules are reloaded manually as of today.

```
root@gds-snc1-prod-db001m1:~ # /etc/rc.d/pf check
Checking pf rules.
root@gds-snc1-prod-db001m1:~ # /etc/rc.d/pf reload
Reloading pf rules.
```

```
root@gds-snc1-prod-db001s1:/etc/pf.conf.d # /etc/rc.d/pf check
Checking pf rules.
root@gds-snc1-prod-db001s1:/etc/pf.conf.d # /etc/rc.d/pf reload
Reloading pf rules.
```


FIXME(pboros@): after all the ansible runs, the shell on the gds_mha user is changed to false because gds_mha is a system user. In order to make MHA work, we should set it back manually on all machines effected with chsh. In our example these machines are gds-snc1-prod-db001m1.snc1, gds-snc1-prod-db001s1.snc1, gds-admin01.snc1. If you didn't run full plays, but used --start-at-task like in the examples above, this step could be skipped. 

```
chsh gds_mha
```

Next step is setting up replication between the master and any slave

```
% ansible-playbook -i inventory/gds-production plays/database-mysql-clone-slave.yml -e "master_server=gds-snc1-prod-db009m1.snc1" -e "slave_server=gds-snc1-prod-db009s1.snc1" -e "instance=taxonomy_auth_prod"
```

Repeat this step for each slave (uses xtrabackup). 

Get some random string for the VRRP passwords:

```
% cat /dev/random | hexdump -n 30| cut -d \  -f 2-| head -n 1 | tr -d " "
a4be5f44899ee4d5d52e6825ec0ab2d5
```

On the master (gds-snc1-prod-db001m1.snc1 in our case), add the following lines to /etc/rc.conf.local:
```
ifconfig_vlan316_alias14="vhid 34 pass a4be5f44899ee4d5d52e6825ec0ab2d5 advskew 50 alias 10.30.16.34/32"
ifconfig_vlan317_alias14="vhid 34 pass 6d753c444f3122de2a4ac2a8fdc22cfd advskew 100 alias 10.30.17.34/32"
```

The alias values should be incremented by one for each set of instances. Make sure you add the aliases to the right instance, the master's interface is vlan316, the slave's interface is vlan317.

On the slave (gd-snc1-prod-db001s1.snc1 in our case), add the following lines to /etc/rc.conf.local:
```
ifconfig_vlan316_alias14="vhid 34 pass a4be5f44899ee4d5d52e6825ec0ab2d5 advskew 100 alias 10.30.16.34/32"
ifconfig_vlan317_alias14="vhid 34 pass 6d753c444f3122de2a4ac2a8fdc22cfd advskew 50 alias 10.30.17.34/32"

```

Notice that for an interface, the VRRP passphrase is the same, but the advskew is different on the servers.

Next, configure the master VIP:
```
root@gds-snc1-prod-db001m1:~ # ifconfig vlan316 vhid 34 pass a4be5f44899ee4d5d52e6825ec0ab2d5 advskew 50 alias 10.30.16.34/32
root@gds-snc1-prod-db001m1:~ # ifconfig vlan316
vlan316: flags=8943<UP,BROADCAST,RUNNING,PROMISC,SIMPLEX,MULTICAST> metric 0 mtu 1500
        options=303<RXCSUM,TXCSUM,TSO4,TSO6>
        ether 00:25:90:a0:54:f6
        inet 10.30.16.230 netmask 0xffffff00 broadcast 10.30.16.255 
        inet 10.30.16.14 netmask 0xffffffff broadcast 10.30.16.14 vhid 14 
        inet 10.30.16.15 netmask 0xffffffff broadcast 10.30.16.15 vhid 15 
        inet 10.30.16.16 netmask 0xffffffff broadcast 10.30.16.16 vhid 16 
        inet 10.30.16.17 netmask 0xffffffff broadcast 10.30.16.17 vhid 17 
        inet 10.30.16.18 netmask 0xffffffff broadcast 10.30.16.18 vhid 18 
        inet 10.30.16.19 netmask 0xffffffff broadcast 10.30.16.19 vhid 19 
        inet 10.30.16.20 netmask 0xffffffff broadcast 10.30.16.20 vhid 20 
        inet 10.30.16.21 netmask 0xffffffff broadcast 10.30.16.21 vhid 21 
        inet 10.30.16.22 netmask 0xffffffff broadcast 10.30.16.22 vhid 22 
        inet 10.30.16.23 netmask 0xffffffff broadcast 10.30.16.23 vhid 23 
        inet 10.30.16.24 netmask 0xffffffff broadcast 10.30.16.24 vhid 24 
        inet 10.30.16.25 netmask 0xffffffff broadcast 10.30.16.25 vhid 25 
        inet 10.30.16.33 netmask 0xffffffff broadcast 10.30.16.33 vhid 33 
        inet 10.30.16.34 netmask 0xffffffff broadcast 10.30.16.34 vhid 34 
        media: Ethernet autoselect
        status: active
        vlan: 316 parent interface: lagg0
        carp: MASTER vhid 14 advbase 1 advskew 50
        carp: MASTER vhid 15 advbase 1 advskew 50
        carp: MASTER vhid 16 advbase 1 advskew 50
        carp: MASTER vhid 17 advbase 1 advskew 50
        carp: MASTER vhid 18 advbase 1 advskew 50
        carp: MASTER vhid 19 advbase 1 advskew 50
        carp: MASTER vhid 20 advbase 1 advskew 50
        carp: MASTER vhid 21 advbase 1 advskew 50
        carp: MASTER vhid 22 advbase 1 advskew 50
        carp: MASTER vhid 23 advbase 1 advskew 50
        carp: MASTER vhid 24 advbase 1 advskew 50
        carp: MASTER vhid 25 advbase 1 advskew 50
        carp: MASTER vhid 33 advbase 1 advskew 50
        carp: MASTER vhid 34 advbase 1 advskew 50
```

```
root@gds-snc1-prod-db001s1:~ # ifconfig vlan316 vhid 34 pass a4be5f44899ee4d5d52e6825ec0ab2d5 advskew 100 alias 10.30.16.34/32
root@gds-snc1-prod-db001s1:~ # ifconfig vlan316
vlan316: flags=8943<UP,BROADCAST,RUNNING,PROMISC,SIMPLEX,MULTICAST> metric 0 mtu 1500
        options=303<RXCSUM,TXCSUM,TSO4,TSO6>
        ether 00:25:90:a0:54:ec
        inet 10.30.16.231 netmask 0xffffff00 broadcast 10.30.16.255 
        inet 10.30.16.14 netmask 0xffffffff broadcast 10.30.16.14 vhid 14 
        inet 10.30.16.15 netmask 0xffffffff broadcast 10.30.16.15 vhid 15 
        inet 10.30.16.16 netmask 0xffffffff broadcast 10.30.16.16 vhid 16 
        inet 10.30.16.17 netmask 0xffffffff broadcast 10.30.16.17 vhid 17 
        inet 10.30.16.18 netmask 0xffffffff broadcast 10.30.16.18 vhid 18 
        inet 10.30.16.19 netmask 0xffffffff broadcast 10.30.16.19 vhid 19 
        inet 10.30.16.20 netmask 0xffffffff broadcast 10.30.16.20 vhid 20 
        inet 10.30.16.21 netmask 0xffffffff broadcast 10.30.16.21 vhid 21 
        inet 10.30.16.22 netmask 0xffffffff broadcast 10.30.16.22 vhid 22 
        inet 10.30.16.23 netmask 0xffffffff broadcast 10.30.16.23 vhid 23 
        inet 10.30.16.24 netmask 0xffffffff broadcast 10.30.16.24 vhid 24 
        inet 10.30.16.25 netmask 0xffffffff broadcast 10.30.16.25 vhid 25 
        inet 10.30.16.33 netmask 0xffffffff broadcast 10.30.16.33 vhid 33 
        inet 10.30.16.34 netmask 0xffffffff broadcast 10.30.16.34 vhid 34 
        media: Ethernet autoselect
        status: active
        vlan: 316 parent interface: lagg0
        carp: BACKUP vhid 14 advbase 1 advskew 100
        carp: BACKUP vhid 15 advbase 1 advskew 100
        carp: BACKUP vhid 16 advbase 1 advskew 100
        carp: BACKUP vhid 17 advbase 1 advskew 100
        carp: BACKUP vhid 18 advbase 1 advskew 100
        carp: BACKUP vhid 19 advbase 1 advskew 100
        carp: BACKUP vhid 20 advbase 1 advskew 100
        carp: BACKUP vhid 21 advbase 1 advskew 100
        carp: BACKUP vhid 22 advbase 1 advskew 100
        carp: BACKUP vhid 23 advbase 1 advskew 100
        carp: BACKUP vhid 24 advbase 1 advskew 100
        carp: BACKUP vhid 25 advbase 1 advskew 100
        carp: BACKUP vhid 33 advbase 1 advskew 100
        carp: BACKUP vhid 34 advbase 1 advskew 100
```

The vlan316 interface is in MASTER state on the master, and in BACKUP state on the slave. This is checked by MHA's replication check.

Configure vlan317 similarly:

```
root@gds-snc1-prod-db001s1:~ # ifconfig vlan317 vhid 34 pass 6d753c444f3122de2a4ac2a8fdc22cfd advskew 50 alias 10.30.17.34/32
root@gds-snc1-prod-db001s1:~ # ifconfig vlan317
vlan317: flags=8943<UP,BROADCAST,RUNNING,PROMISC,SIMPLEX,MULTICAST> metric 0 mtu 1500
        options=303<RXCSUM,TXCSUM,TSO4,TSO6>
        ether 00:25:90:a0:54:ec
        inet 10.30.17.231 netmask 0xffffff00 broadcast 10.30.17.255 
        inet 10.30.17.14 netmask 0xffffffff broadcast 10.30.17.14 vhid 14 
        inet 10.30.17.15 netmask 0xffffffff broadcast 10.30.17.15 vhid 15 
        inet 10.30.17.16 netmask 0xffffffff broadcast 10.30.17.16 vhid 16 
        inet 10.30.17.17 netmask 0xffffffff broadcast 10.30.17.17 vhid 17 
        inet 10.30.17.18 netmask 0xffffffff broadcast 10.30.17.18 vhid 18 
        inet 10.30.17.19 netmask 0xffffffff broadcast 10.30.17.19 vhid 19 
        inet 10.30.17.20 netmask 0xffffffff broadcast 10.30.17.20 vhid 20 
        inet 10.30.17.21 netmask 0xffffffff broadcast 10.30.17.21 vhid 21 
        inet 10.30.17.22 netmask 0xffffffff broadcast 10.30.17.22 vhid 22 
        inet 10.30.17.23 netmask 0xffffffff broadcast 10.30.17.23 vhid 23 
        inet 10.30.17.24 netmask 0xffffffff broadcast 10.30.17.24 vhid 24 
        inet 10.30.17.25 netmask 0xffffffff broadcast 10.30.17.25 vhid 25 
        inet 10.30.17.33 netmask 0xffffffff broadcast 10.30.17.33 vhid 33 
        inet 10.30.17.34 netmask 0xffffffff broadcast 10.30.17.34 vhid 34 
        media: Ethernet autoselect
        status: active
        vlan: 317 parent interface: lagg0
        carp: MASTER vhid 14 advbase 1 advskew 50
        carp: MASTER vhid 15 advbase 1 advskew 50
        carp: MASTER vhid 16 advbase 1 advskew 50
        carp: MASTER vhid 17 advbase 1 advskew 50
        carp: MASTER vhid 18 advbase 1 advskew 50
        carp: MASTER vhid 19 advbase 1 advskew 50
        carp: MASTER vhid 20 advbase 1 advskew 50
        carp: BACKUP vhid 21 advbase 1 advskew 50
        carp: MASTER vhid 22 advbase 1 advskew 50
        carp: MASTER vhid 23 advbase 1 advskew 50
        carp: MASTER vhid 24 advbase 1 advskew 50
        carp: MASTER vhid 25 advbase 1 advskew 50
        carp: MASTER vhid 33 advbase 1 advskew 50
        carp: MASTER vhid 34 advbase 1 advskew 50

```

```
root@gds-snc1-prod-db001m1:~ # ifconfig vlan317
vlan317: flags=8943<UP,BROADCAST,RUNNING,PROMISC,SIMPLEX,MULTICAST> metric 0 mtu 1500
        options=303<RXCSUM,TXCSUM,TSO4,TSO6>
        ether 00:25:90:a0:54:f6
        inet 10.30.17.230 netmask 0xffffff00 broadcast 10.30.17.255 
        inet 10.30.17.14 netmask 0xffffffff broadcast 10.30.17.14 vhid 14 
        inet 10.30.17.15 netmask 0xffffffff broadcast 10.30.17.15 vhid 15 
        inet 10.30.17.16 netmask 0xffffffff broadcast 10.30.17.16 vhid 16 
        inet 10.30.17.17 netmask 0xffffffff broadcast 10.30.17.17 vhid 17 
        inet 10.30.17.18 netmask 0xffffffff broadcast 10.30.17.18 vhid 18 
        inet 10.30.17.19 netmask 0xffffffff broadcast 10.30.17.19 vhid 19 
        inet 10.30.17.20 netmask 0xffffffff broadcast 10.30.17.20 vhid 20 
        inet 10.30.17.21 netmask 0xffffffff broadcast 10.30.17.21 vhid 21 
        inet 10.30.17.22 netmask 0xffffffff broadcast 10.30.17.22 vhid 22 
        inet 10.30.17.23 netmask 0xffffffff broadcast 10.30.17.23 vhid 23 
        inet 10.30.17.24 netmask 0xffffffff broadcast 10.30.17.24 vhid 24 
        inet 10.30.17.25 netmask 0xffffffff broadcast 10.30.17.25 vhid 25 
        inet 10.30.17.33 netmask 0xffffffff broadcast 10.30.17.33 vhid 33 
        inet 10.30.17.34 netmask 0xffffffff broadcast 10.30.17.34 vhid 34 
        media: Ethernet autoselect
        status: active
        vlan: 317 parent interface: lagg0
        carp: BACKUP vhid 14 advbase 1 advskew 100
        carp: BACKUP vhid 15 advbase 1 advskew 100
        carp: BACKUP vhid 16 advbase 1 advskew 100
        carp: BACKUP vhid 17 advbase 1 advskew 100
        carp: BACKUP vhid 18 advbase 1 advskew 100
        carp: BACKUP vhid 19 advbase 1 advskew 100
        carp: BACKUP vhid 20 advbase 1 advskew 100
        carp: MASTER vhid 21 advbase 1 advskew 100
        carp: BACKUP vhid 22 advbase 1 advskew 100
        carp: BACKUP vhid 23 advbase 1 advskew 100
        carp: BACKUP vhid 24 advbase 1 advskew 100
        carp: BACKUP vhid 25 advbase 1 advskew 100
        carp: BACKUP vhid 33 advbase 1 advskew 100
        carp: BACKUP vhid 34 advbase 1 advskew 100
```

After this, run MHA's replication check:
```
18:44 c_pboros@gds-admin01 % sudo su - gds_mha
gds_mha@gds-admin01:~ % masterha_check_repl --conf=scamtracker_prod-mha.cnf                                                                                         
Thu Oct 30 18:54:48 2014 - [info] Reading default configuration from /etc/masterha_default.cnf..
Thu Oct 30 18:54:48 2014 - [info] Reading application default configuration from scamtracker_prod-mha.cnf..
Thu Oct 30 18:54:48 2014 - [info] Reading server configuration from scamtracker_prod-mha.cnf..
  Creating /tmp if not exists..    ok.
  Checking output directory is accessible or not..
   ok.
  Binlog found at /var/groupon/percona/scamtracker_prod/log, up to master-bin.000003
  Checking slave recovery environment settings..
    Relay log found at /var/groupon/percona/scamtracker_prod/log, up to slave-relay-bin.000002
    Temporary relay log file is /var/groupon/percona/scamtracker_prod/log/slave-relay-bin.000002
    Testing mysql connection and privileges..Warning: Using a password on the command line interface can be insecure.
 done.
    Testing mysqlbinlog output.. done.
    Cleaning up test file(s).. done.
        carp: MASTER vhid 34 advbase 1 advskew 50
INFO: vlan316 interface is CARP master

MySQL Replication Health is OK.

```

After this, the setup is DONE!

Let's connect to the vip from the admin box.

```
gds_mha@gds-admin01:~ % mysql -h10.30.16.34 -ugds_mha -P20014 -pmhamysqlpassword
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 109
Server version: 5.6.20-68.0-log Source distribution

Copyright (c) 2009-2014 Percona LLC and/or its affiliates
Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> select @@hostname;
+----------------------------+
| @@hostname                 |
+----------------------------+
| gds-snc1-prod-db001m1.snc1 |
+----------------------------+
1 row in set (0.00 sec)
```

So, the VIP is now on the master.

Let's flip is over. 

```
gds_mha@gds-admin01:~ % masterha_master_switch --conf=scamtracker_prod-mha.cnf --master_state=alive --new_master_host=gds-snc1-proc-db001s1.snc1 --orig_master_is_ne
w_slave --interactive=0
Thu Oct 30 19:00:20 2014 - [info] MHA::MasterRotate version 0.56.
Thu Oct 30 19:00:20 2014 - [info] Starting online master switch..
Thu Oct 30 19:00:20 2014 - [info] 
Thu Oct 30 19:00:20 2014 - [info] * Phase 1: Configuration Check Phase..
Thu Oct 30 19:00:20 2014 - [info] 
Thu Oct 30 19:00:20 2014 - [info] Reading default configuration from /etc/masterha_default.cnf..
Thu Oct 30 19:00:20 2014 - [info] Reading application default configuration from scamtracker_prod-mha.cnf..
Thu Oct 30 19:00:20 2014 - [info] Reading server configuration from scamtracker_prod-mha.cnf..
ARGS: $VAR1 = [
          '--command=stop',
          '--orig_master_host=gds-snc1-prod-db001m1.snc1',
          '--orig_master_ip=10.20.114.179',
          '--orig_master_port=20014',
          '--orig_master_user=gds_mha',
          '--orig_master_password=mhamysqlpassword',
          '--new_master_host=gds-snc1-prod-db001s1.snc1',
          '--new_master_ip=10.20.114.31',
          '--new_master_port=20014',
          '--new_master_user=gds_mha',
          '--new_master_password=mhamysqlpassword',
          '--orig_master_ssh_user=gds_mha',
          '--new_master_ssh_user=gds_mha',
          '--orig_master_is_new_slave'
        ];
Unknown option: orig_master_ssh_user
Unknown option: new_master_ssh_user
Unknown option: orig_master_is_new_slave
Thu Oct 30 19:00:20 2014 972453 Set read_only on the new master.. ok.
Thu Oct 30 19:00:20 2014 975127 Waiting all running 1 threads are disconnected.. (max 1500 milliseconds)
{'Time' => '0','db' => 'percona','Id' => '85','User' => 'pt_heartbeat','State' => '','Command' => 'Sleep','Rows_examined' => '0','Info' => undef,'Rows_sent' => '0',
'Host' => 'localhost'}
Thu Oct 30 19:00:21 2014 510175 Waiting all running 1 threads are disconnected.. (max 1000 milliseconds)
{'Time' => '0','db' => 'percona','Id' => '85','User' => 'pt_heartbeat','State' => '','Command' => 'Sleep','Rows_examined' => '0','Info' => undef,'Rows_sent' => '0',
'Host' => 'localhost'}
Thu Oct 30 19:00:21 2014 992055 Set read_only=1 on the orig master.. ok.
Thu Oct 30 19:00:21 2014 993354 Waiting all running 1 queries are disconnected.. (max 500 milliseconds)
{'Time' => '0','db' => 'percona','Id' => '85','User' => 'pt_heartbeat','State' => '','Command' => 'Sleep','Rows_examined' => '0','Info' => undef,'Rows_sent' => '0',
'Host' => 'localhost'}
Thu Oct 30 19:00:22 2014 468892 Killing all application threads..
Thu Oct 30 19:00:22 2014 469222 done.
STOP ARGS: $VAR1 = [];
ARGS: $VAR1 = [
          '--command=start',
          '--orig_master_host=gds-snc1-prod-db001m1.snc1',
          '--orig_master_ip=10.20.114.179',
          '--orig_master_port=20014',
          '--orig_master_user=gds_mha',
          '--orig_master_password=mhamysqlpassword',
          '--new_master_host=gds-snc1-prod-db001s1.snc1',
          '--new_master_ip=10.20.114.31',
          '--new_master_port=20014',
          '--new_master_user=gds_mha',
          '--new_master_password=mhamysqlpassword',
          '--orig_master_ssh_user=gds_mha',
          '--new_master_ssh_user=gds_mha',
          '--orig_master_is_new_slave'
        ];
Unknown option: orig_master_ssh_user
Unknown option: new_master_ssh_user
Unknown option: orig_master_is_new_slave
Thu Oct 30 19:00:22 2014 615162 Set read_only=0 on the new master.
ifconfig: unknown state

```

The output right now is normal to be like this, FIXME(@pboros). Notice that the command completes in the matter of SECONDS!

```
mysql> select @@hostname;
ERROR 2006 (HY000): MySQL server has gone away
No connection. Trying to reconnect...
Connection id:    17
Current database: *** NONE ***

+----------------------------+
| @@hostname                 |
+----------------------------+
| gds-snc1-prod-db001s1.snc1 |
+----------------------------+
1 row in set (0.01 sec)
```

Our client reconnected, and the new master is indeed s1. Flipping back is similar.
```
gds_mha@gds-admin01:~ % masterha_master_switch --conf=scamtracker_prod-mha.cnf --master_state=alive --new_master_host=gds-snc1-proc-db001m1.snc1 --orig_master_is_new_slave --interactive=0                                                                                                                                             
```

Let's kill the master intentionally to show dead switchover.

```
root@gds-snc1-prod-db001m1:/var/service/scamtracker_prod-gds_prod_snc1_db001-mysql # sv down .
root@gds-snc1-prod-db001m1:/var/service/scamtracker_prod-gds_prod_snc1_db001-mysql # sv stat .
run: .: (pid 92685) 5774s, want down, got TERM; run: log: (pid 92684) 5774s
root@gds-snc1-prod-db001m1:/var/service/scamtracker_prod-gds_prod_snc1_db001-mysql # sv stat .
run: .: (pid 92685) 5778s, want down, got TERM; run: log: (pid 92684) 5778s
root@gds-snc1-prod-db001m1:/var/service/scamtracker_prod-gds_prod_snc1_db001-mysql # sv stat .
run: .: (pid 92685) 5781s, want down, got TERM; run: log: (pid 92684) 5781s
root@gds-snc1-prod-db001m1:/var/service/scamtracker_prod-gds_prod_snc1_db001-mysql # sv stat .
down: .: 2s, normally up; run: log: (pid 92684) 5784s
root@gds-snc1-prod-db001m1:/var/service/scamtracker_prod-gds_prod_snc1_db001-mysql # sv stat .
down: .: 3s, normally up; run: log: (pid 92684) 5785s
```

Until it's want down, not down mysql is still shutting down (sv down is a graceful shutdown).

The client will see in this case that the server is down.

```
mysql> select @@hostname;
ERROR 2013 (HY000): Lost connection to MySQL server during query
```

In order to flip over to s1, we have to use the "dead" switching method.
```
gds_mha@gds-admin01:~ % masterha_master_switch --conf=scamtracker_prod-mha.cnf --master_state=dead --dead_master_host=gds-snc1-prod-db001m1.snc1 --dead_master_port=20014 --new_master_host=gds-snc1-prod-db001s1.snc1                                                                                                                  --dead_master_ip=<dead_master_ip> is not set. Using 10.20.114.179.
Thu Oct 30 19:08:38 2014 - [info] Reading default configuration from /etc/masterha_default.cnf..
Thu Oct 30 19:08:38 2014 - [info] Reading application default configuration from scamtracker_prod-mha.cnf..
Thu Oct 30 19:08:38 2014 - [info] Reading server configuration from scamtracker_prod-mha.cnf..
Master gds-snc1-prod-db001m1.snc1(10.20.114.179:20014) is dead. Proceed? (yes/NO): yes
  Creating /tmp if not exists..    ok.
 Concat binary/relay logs from master-bin.000003 pos 43949 to master-bin.000003 EOF into /tmp/saved_master_binlog_from_gds-snc1-prod-db001m1.snc1_20014_20141030190838.binlog ..
 Binlog Checksum enabled
  Dumping binlog format description event, from position 0 to 120.. ok.
  Dumping effective binlog data from /var/groupon/percona/scamtracker_prod/log/master-bin.000003 position 43949 to tail(43972).. ok.
 Binlog Checksum enabled
 Concat succeeded.
saved_master_binlog_from_gds-snc1-prod-db001m1.snc1_20014_20141030190838.binlog                                                   100%  143     0.1KB/s   00:00    

Starting master switch from gds-snc1-prod-db001m1.snc1(10.20.114.179:20014) to gds-snc1-prod-db001s1.snc1(10.20.114.31:20014)? (yes/NO): yes
saved_master_binlog_from_gds-snc1-prod-db001m1.snc1_20014_20141030190838.binlog                                                   100%  143     0.1KB/s   00:00    
Set read_only=0 on the new master.
```

After this, the client reconnects, just like a real application should.
```
mysql> select @@hostname;
ERROR 2006 (HY000): MySQL server has gone away
No connection. Trying to reconnect...
Connection id:    29
Current database: *** NONE ***

+----------------------------+
| @@hostname                 |
+----------------------------+
| gds-snc1-prod-db001s1.snc1 |
+----------------------------+
1 row in set (0.00 sec)
```

Brining the new master back is practically slave cloning.

WARNING! The hosts: part of the slave cloning playbook has hardcoded hostnames, make sure you swapped master and slave before doing this. 

```
% ansible-playbook -i inventory/gds-production plays/database-mysql-clone-slave.yml -e "master_server=gds-snc1-prod-db001s1.snc1" -e "slave_server=gds-snc1-prod-db001m1.snc1" -e "instance=scamtracker_prod" 
```

After bringing a dead node online, you might have to adjust the CARP interfaces manually. In order to put a vhid in master mode, do:
```
ifconfig vlan316 vhid 34 state master
```

In order to put into backup mode:
```
ifconfig vlan317 vhid 34 state slave
```

Monitoring via ops-config

In /var/tmp/ops-config-monitoring, ansible generates the ymls that are needed to monitor these hosts via grapher and nagios.

```
root@gds-snc1-prod-db001s1:~ # ls /var/tmp/ops-config-monitoring/
client_id_prod.yml    getaways_search_prod.yml  killbill_latam_prod.yml   po_manager_prod.yml   scamtracker_prod.yml
cs_tools_prod.yml   getaways_security_prod.yml  killbill_prod.yml   pricing_dim_prod.yml    service_portal_prod.yml
dynamic_pricing_prod.yml  glive_gia_prod.yml    merchant_ssd_prod.yml   pricing_s4_prod.yml
espresso_prod.yml   glive_inventory_prod.yml  mission_control_prod.yml  rocketman_prod.yml
```

The following command will give you the yaml which you should paste in the given machine's host yml in ops-config.
```
root@gds-snc1-prod-db001s1:~ # cat /var/tmp/ops-config-monitoring/*
```
