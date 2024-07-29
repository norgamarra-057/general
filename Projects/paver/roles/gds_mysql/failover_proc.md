On the gds-admin02.snc1 box, the MHA configuration for non-production databases can be found. You have to use the gds_mha user to check them.

```
gds_mha@gds-admin02:~ % ls
gds_mysql_test01-mha.cnf  gds_mysql_test02-mha.cnf
```

In this test, we will fail over both of them both in a graceful and in a non-graceful fashion.

First, we check the state of the clusters. We have to run the ssh and the replication checks on both.
```
gds_mha@gds-admin02:~ % masterha_check_ssh --conf=gds_mysql_test01-mha.cnf
Wed Jan 14 20:38:31 2015 - [warning] Global configuration file /etc/masterha_default.cnf not found. Skipping.
Wed Jan 14 20:38:31 2015 - [info] Reading application default configuration from gds_mysql_test01-mha.cnf..
Wed Jan 14 20:38:31 2015 - [info] Reading server configuration from gds_mysql_test01-mha.cnf..
Wed Jan 14 20:38:31 2015 - [info] Starting SSH connection tests..
Wed Jan 14 20:38:32 2015 - [debug] 
Wed Jan 14 20:38:31 2015 - [debug]  Connecting via SSH from gds_mha@test-db1.snc1(10.20.43.171:22) to gds_mha@test-db2.snc1(10.20.43.167:22)..
Wed Jan 14 20:38:32 2015 - [debug]   ok.
Wed Jan 14 20:38:32 2015 - [debug] 
Wed Jan 14 20:38:32 2015 - [debug]  Connecting via SSH from gds_mha@test-db2.snc1(10.20.43.167:22) to gds_mha@test-db1.snc1(10.20.43.171:22)..
Wed Jan 14 20:38:32 2015 - [debug]   ok.
Wed Jan 14 20:38:32 2015 - [info] All SSH connection tests passed successfully.
gds_mha@gds-admin02:~ % masterha_check_ssh --conf=gds_mysql_test02-mha.cnf
Wed Jan 14 20:38:38 2015 - [warning] Global configuration file /etc/masterha_default.cnf not found. Skipping.
Wed Jan 14 20:38:38 2015 - [info] Reading application default configuration from gds_mysql_test02-mha.cnf..
Wed Jan 14 20:38:38 2015 - [info] Reading server configuration from gds_mysql_test02-mha.cnf..
Wed Jan 14 20:38:38 2015 - [info] Starting SSH connection tests..
Wed Jan 14 20:38:39 2015 - [debug] 
Wed Jan 14 20:38:38 2015 - [debug]  Connecting via SSH from gds_mha@test-db1.snc1(10.20.43.171:22) to gds_mha@test-db2.snc1(10.20.43.167:22)..
Wed Jan 14 20:38:39 2015 - [debug]   ok.
Wed Jan 14 20:38:39 2015 - [debug] 
Wed Jan 14 20:38:39 2015 - [debug]  Connecting via SSH from gds_mha@test-db2.snc1(10.20.43.167:22) to gds_mha@test-db1.snc1(10.20.43.171:22)..
Wed Jan 14 20:38:39 2015 - [debug]   ok.
Wed Jan 14 20:38:39 2015 - [info] All SSH connection tests passed successfully.
```

```
gds_mha@gds-admin02:~ % masterha_check_repl --conf=gds_mysql_test01-mha.cnf
Wed Jan 14 20:39:30 2015 - [warning] Global configuration file /etc/masterha_default.cnf not found. Skipping.
Wed Jan 14 20:39:30 2015 - [info] Reading application default configuration from gds_mysql_test01-mha.cnf..
Wed Jan 14 20:39:30 2015 - [info] Reading server configuration from gds_mysql_test01-mha.cnf..
  Creating /tmp if not exists..    ok.
  Checking output directory is accessible or not..
   ok.
  Binlog found at /var/groupon/percona/gds_mysql_test01/log, up to master-bin.000003
  Checking slave recovery environment settings..
    Relay log found at /var/groupon/percona/gds_mysql_test01/log, up to slave-relay-bin.000002
    Temporary relay log file is /var/groupon/percona/gds_mysql_test01/log/slave-relay-bin.000002
    Testing mysql connection and privileges..Warning: Using a password on the command line interface can be insecure.
 done.
    Testing mysqlbinlog output.. done.
    Cleaning up test file(s).. done.
  carp: MASTER vhid 64 advbase 1 advskew 50
INFO: lagg0 interface is CARP master

MySQL Replication Health is OK.
gds_mha@gds-admin02:~ % masterha_check_repl --conf=gds_mysql_test02-mha.cnf
Wed Jan 14 20:39:44 2015 - [warning] Global configuration file /etc/masterha_default.cnf not found. Skipping.
Wed Jan 14 20:39:44 2015 - [info] Reading application default configuration from gds_mysql_test02-mha.cnf..
Wed Jan 14 20:39:44 2015 - [info] Reading server configuration from gds_mysql_test02-mha.cnf..
  Creating /tmp if not exists..    ok.
  Checking output directory is accessible or not..
   ok.
  Binlog found at /var/groupon/percona/gds_mysql_test02/log, up to master-bin.000003
  Checking slave recovery environment settings..
    Relay log found at /var/groupon/percona/gds_mysql_test02/log, up to slave-relay-bin.000002
    Temporary relay log file is /var/groupon/percona/gds_mysql_test02/log/slave-relay-bin.000002
    Testing mysql connection and privileges..Warning: Using a password on the command line interface can be insecure.
 done.
    Testing mysqlbinlog output.. done.
    Cleaning up test file(s).. done.
  carp: MASTER vhid 66 advbase 1 advskew 50
INFO: lagg0 interface is CARP master

MySQL Replication Health is OK.
```

The cluster definitiion can be checked in paver/group_vars/gds_stg_test_dbs.yml.

```
20:50 c_pboros@gds-admin01 % cat group_vars/gds_stg_test_dbs.yml 
---
gds_carp_peers:
  - 10.20.43.171
  - 10.20.43.167
gds_carp_interfaces:
  - lagg0

gds_instances:
  gds_mysql_test01:
    type: mysql
    write_origin: snc1
    firewall_priority: 150
    unix_user: gds_uid60001
    nodes:
      - test-db1.snc1
      - test-db2.snc1
    master_carp_interface: lagg0
    slave_carp_interface: lagg0
    vhid: 64
    slave_vhid: 65
    master_vip: 10.20.43.120
    slave_vips:
      - 10.20.43.124
    replication_ips:
      - 10.20.43.171 # test-db1.snc1
      - 10.20.43.167 # test-db2.snc1
    firewall_permitted_src_cidrs:
      - 10.20.32.17 # dev1.snc1
    dba_account_name: gds_mysql_test01_dba
    dba_src_cirds:
      - 10.20.32.17 # dev1.snc1
    ports:
      mysqld: 20001
  gds_mysql_test02:
    type: mysql
    write_origin: snc1
    firewall_priority: 150
    unix_user: gds_uid60002
    nodes:
      - test-db1.snc1
      - test-db2.snc1
    master_carp_interface: lagg0
    slave_carp_interface: lagg0
    vhid: 66
    slave_vhid: 67
    master_vip: 10.20.43.44
    slave_vips:
      - 10.20.43.104
    replication_ips:
      - 10.20.43.171 # test-db1.snc1
      - 10.20.43.167 # test-db2.snc1
    firewall_permitted_src_cidrs:
      - 10.20.32.17 # dev1.snc1
    dba_account_name: gds_mysql_test02_dba
    dba_src_cirds:
      - 10.20.32.17 # dev1.snc1
    ports:
      mysqld: 20002
```

Let's create some workload for the cluster for the purpose of testing. Let's create a user and a database for testing.

```
root@test-db1:~ # mi.sh -s gds_mysql_test01
root@test-db1:~ # mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 52
Server version: 5.6.20-68.0-log GDS Percona Server(GPL), built from source

Copyright (c) 2009-2014 Percona LLC and/or its affiliates
Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> create database sbtest;
Query OK, 1 row affected (0.00 sec)

mysql> grant all on sbtest.* to 'sbtest'@'%' identified by 'sbtest';
Query OK, 0 rows affected (0.00 sec)
```

Generate some test data:
```
% sysbench --test=/usr/local/share/sysbench/tests/db/parallel_prepare.lua --mysql-user=sbtest --mysql-password=sbtest --mysql-host=10.20.43.120 --mysql-port=20001 --mysql-ignore-errors=all --oltp-table-size=10000 --oltp-tables-count=16 --num-threads=16 run
sysbench 0.5:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 16
Random number generator seed is 0 and will be ignored


Threads started!

thread prepare0
Creating table 'sbtest1'...
thread prepare14
thread prepare13
thread prepare11
thread prepare9
thread prepare2
thread prepare7
thread prepare8thread prepare4

Creating table 'sbtest15'...
Creating table 'sbtest14'...
Creating table 'sbtest12'...
thread prepare10
Creating table 'sbtest10'...
Creating table 'sbtest3'...
Creating table 'sbtest8'...
Creating table 'sbtest9'...
Creating table 'sbtest5'...
Creating table 'sbtest11'...
thread prepare12
thread prepare1
thread prepare6thread prepare15thread prepare5
Creating table 'sbtest2'...


Creating table 'sbtest13'...Creating table 'sbtest6'...

thread prepare3
Creating table 'sbtest7'...
Creating table 'sbtest16'...
Creating table 'sbtest4'...
Inserting 10000 records into 'sbtest11'
Inserting 10000 records into 'sbtest5'
Inserting 10000 records into 'sbtest14'
Inserting 10000 records into 'sbtest2'
Inserting 10000 records into 'sbtest8'
Inserting 10000 records into 'sbtest10'
Inserting 10000 records into 'sbtest12'
Inserting 10000 records into 'sbtest15'
Inserting 10000 records into 'sbtest7'
Inserting 10000 records into 'sbtest9'
Inserting 10000 records into 'sbtest6'
Inserting 10000 records into 'sbtest4'
Inserting 10000 records into 'sbtest13'
Inserting 10000 records into 'sbtest1'
Inserting 10000 records into 'sbtest3'
Inserting 10000 records into 'sbtest16'
OLTP test statistics:
    queries performed:
        read:                            0
        write:                           64
        other:                           32
        total:                           96
    transactions:                        0      (0.00 per sec.)
    deadlocks:                           0      (0.00 per sec.)
    read/write requests:                 64     (27.15 per sec.)
    other operations:                    32     (13.57 per sec.)

General statistics:
    total time:                          2.3573s
    total number of events:              10000
    total time taken by event execution: 0.0028s
    response time:
         min:                                  0.00ms
         avg:                                  0.00ms
         max:                                  0.05ms
         approx.  95 percentile:               0.00ms

Threads fairness:
    events (avg/stddev):           625.0000/2420.61
    execution time (avg/stddev):   0.0002/0.00


Time spent in user mode   (CPU seconds) : 14.393s
Time spent in kernel mode (CPU seconds) : 0.055s
Total time                              : 0:02.37s
CPU utilization (percentage)            : 609.2%
Times the process was swapped           : 0
Times of major page faults              : 3
Times of minor page faults              : 4133
```

Start a benchmark, while switching:
```
19:31 c_pboros@gds-admin02 % sysbench --test=/usr/local/share/sysbench/tests/db/oltp.lua --mysql-user=sbtest --mysql-password=sbtest --mysql-host=10.20.43.120 --mysql-port=20001 --mysql-ignore-errors=all --oltp-table-size=10000 --oltp-tables-count=16 --num-threads=4 --report-interval=1 --max-requests=0 --max-time=0 run

(output truncated)

[  62s] threads: 4, tps: 499.62, reads: 6990.62, writes: 1998.46, response time: 9.58ms (95%), errors: 0.00, reconnects:  0.00
[  63s] threads: 4, tps: 514.61, reads: 7187.94, writes: 2058.43, response time: 9.48ms (95%), errors: 0.00, reconnects:  0.00
[  64s] threads: 4, tps: 180.13, reads: 2529.50, writes: 720.51, response time: 9.60ms (95%), errors: 0.00, reconnects:  0.00
[  65s] threads: 4, tps: 0.00, reads: 0.00, writes: 0.00, response time: 0.00ms (95%), errors: 0.00, reconnects:  0.00
[  66s] threads: 4, tps: 0.00, reads: 0.00, writes: 0.00, response time: 0.00ms (95%), errors: 0.00, reconnects:  0.00
[  67s] threads: 4, tps: 102.59, reads: 1482.50, writes: 414.37, response time: 10.08ms (95%), errors: 0.00, reconnects:  4.02
[  68s] threads: 4, tps: 469.36, reads: 6574.09, writes: 1877.46, response time: 9.42ms (95%), errors: 0.00, reconnects:  0.00
[  69s] threads: 4, tps: 470.96, reads: 6588.46, writes: 1883.85, response time: 9.42ms (95%), errors: 0.00, reconnects:  0.00
```
gds_mha@gds-admin02:~ % masterha_master_switch --conf gds_mysql_test01-mha.cnf --master_state alive --new_master_host test-db2.snc1 --orig_master_is_new_slave --interactive=0
```

The switchover takes roughly 4 seconds (failure in the first benchmark, after sleep 1, the benchmark is able to start and service transactions). If the SSH control sockets exists already, the switchover takes less than a second.

Let's switch back.
```
gds_mha@gds-admin02:~ % masterha_master_switch --conf gds_mysql_test01-mha.cnf --master_state alive --new_master_host test-db1.snc1 --orig_master_is_new_slave --interactive=0
```

And shut down the master.

```
root@test-db1:/var/service/gds_mysql_test01-gds_stg_test_dbs-mysql # sv down .
```
[  12s] threads: 4, tps: 174.48, reads: 2441.69, writes: 693.90, response time: 31.75ms (95%), errors: 0.00, reconnects:  0.00
[  13s] threads: 4, tps: 172.01, reads: 2409.15, writes: 691.04, response time: 31.38ms (95%), errors: 0.00, reconnects:  0.00
[  14s] threads: 4, tps: 145.99, reads: 2000.87, writes: 568.96, response time: 31.99ms (95%), errors: 0.00, reconnects:  0.00
[  15s] threads: 4, tps: 0.00, reads: 0.00, writes: 0.00, response time: 0.00ms (95%), errors: 0.00, reconnects:  0.00
[  16s] threads: 4, tps: 0.00, reads: 0.00, writes: 0.00, response time: 0.00ms (95%), errors: 0.00, reconnects:  0.00
[  17s] threads: 4, tps: 0.00, reads: 0.00, writes: 0.00, response time: 0.00ms (95%), errors: 0.00, reconnects:  0.00
[  18s] threads: 4, tps: 0.00, reads: 0.00, writes: 0.00, response time: 0.00ms (95%), errors: 0.00, reconnects:  0.00
[  19s] threads: 4, tps: 0.00, reads: 0.00, writes: 0.00, response time: 0.00ms (95%), errors: 0.00, reconnects:  0.00
```

Rebuilding the slave server:
```
21:00 c_pboros@gds-admin01 % ansible-playbook -i inventory/gds-staging plays/database-mysql-clone-slave.yml -e "master_server=test-db2.snc1" -e "slave_server=test-db1.snc1" -e "instance=gds_mysql_test01" -e "instance_port=20001" -e "instance_user=gds_uid60001" -e "instance_group=gds_stg_test_dbs"

PLAY [Prepare slave] ********************************************************** 

GATHERING FACTS *************************************************************** 
ok: [test-db1.snc1]

TASK: [assert ] *************************************************************** 
ok: [test-db1.snc1]

TASK: [Stop slave MySQL server] *********************************************** 
changed: [test-db1.snc1]

TASK: [Wipe slave datadir] **************************************************** 
changed: [test-db1.snc1]

TASK: [Wipe slave logdir] ***************************************************** 
changed: [test-db1.snc1]

TASK: [Wipe error.log] ******************************************************** 
changed: [test-db1.snc1]

TASK: [Start socat listener] ************************************************** 
<job 186075084183.41303> finished on test-db1.snc1

PLAY [Stream from master] ***************************************************** 

GATHERING FACTS *************************************************************** 
ok: [test-db2.snc1]

TASK: [assert ] *************************************************************** 
ok: [test-db2.snc1]

TASK: [stream backup] ********************************************************* 
changed: [test-db2.snc1]

PLAY [Start MySQL on slave] *************************************************** 

TASK: [assert ] *************************************************************** 
ok: [test-db1.snc1]

TASK: [run apply log] ********************************************************* 
changed: [test-db1.snc1]

TASK: [chown to user] ********************************************************* 
changed: [test-db1.snc1]

TASK: [Start MySQL server] **************************************************** 
changed: [test-db1.snc1]

TASK: [Wait for mysql to start] *********************************************** 
ok: [test-db1.snc1]

TASK: [Get master_log_file] *************************************************** 
changed: [test-db1.snc1]

TASK: [Get master_log_pos] **************************************************** 
changed: [test-db1.snc1]

TASK: [Configure replication] ************************************************* 
changed: [test-db1.snc1]

TASK: [Start slave] *********************************************************** 
changed: [test-db1.snc1]

PLAY RECAP ******************************************************************** 
test-db1.snc1              : ok=17   changed=11   unreachable=0    failed=0   
test-db2.snc1              : ok=3    changed=1    unreachable=0    failed=0   
```

Check replication health afterwards:
```
gds_mha@gds-admin02:~ % masterha_check_repl --conf 
gds_mysql_test01-mha.cnf  gds_mysql_test02-mha.cnf  sysbench/
gds_mha@gds-admin02:~ % masterha_check_repl --conf gds_mysql_test01-mha.cnf 
Thu Jan 15 21:02:10 2015 - [warning] Global configuration file /etc/masterha_default.cnf not found. Skipping.
Thu Jan 15 21:02:10 2015 - [info] Reading application default configuration from gds_mysql_test01-mha.cnf..
Thu Jan 15 21:02:10 2015 - [info] Reading server configuration from gds_mysql_test01-mha.cnf..
  Creating /tmp if not exists..    ok.
  Checking output directory is accessible or not..
   ok.
  Binlog found at /var/groupon/percona/gds_mysql_test01/log, up to master-bin.000001
  Checking slave recovery environment settings..
    Relay log found at /var/groupon/percona/gds_mysql_test01/log, up to slave-relay-bin.000002
    Temporary relay log file is /var/groupon/percona/gds_mysql_test01/log/slave-relay-bin.000002
    Testing mysql connection and privileges..Warning: Using a password on the command line interface can be insecure.
 done.
    Testing mysqlbinlog output.. done.
    Cleaning up test file(s).. done.
  carp: MASTER vhid 64 advbase 1 advskew 100
INFO: lagg0 interface is CARP master

MySQL Replication Health is OK.
```
