# Percona Playback based cache replication for GDS instances

## Configuration

Percona playback based cache replication can be configured between any 2 machines in a GDS cluster. 
The configuration format is the following.

```
  9 gds_instances:
 10   gds_mysql_test01:
 11     type: mysql
 12     write_origin: snc1
 13     firewall_priority: 150
 14     unix_user: gds_uid60001
 15     nodes:
 16       - test-db1.snc1
 17       - test-db2.snc1
 18     master_carp_interface: lagg0
 19     slave_carp_interface: lagg0
 20     vhid: 64
 21     slave_vhid: 65
 22     master_vip: 10.20.43.120
 23     slave_vips:
 24       - 10.20.43.124
 25     replication_ips:
 26       - 10.20.43.171 # test-db1.snc1
 27       - 10.20.43.167 # test-db2.snc1
 28     firewall_permitted_src_cidrs:
 29       - 10.20.32.17 # dev1.snc1
 30       - 10.22.74.119 # gds-admin01.snc1
 31     dba_account_name: gds_mysql_test01_dba
 32     dba_src_cirds:
 33       - 10.20.32.17 # dev1.snc1
 34     ports:
 35       mysqld: 20001
 36     playback_enabled: true
 37     playback:
 38       peers:
 39         - node: test-db1.snc1
 40           peer: test-db2.snc1
 41         - node: test-db2.snc1
 42           peer: test-db1.snc1
 43       manage_mysql_slowlogd: 1
 44       mysql_user_to_check: sbtest
 45       user: playback_user
 46       password: mee5pieK
 47       schema: sbtest
 48       thread_pool_size: 100
 49       user_connection_threshold: 6
 50       playback_connection_timeout: 20
 51       mysql_slowlogd_port: 30001
```

From line 36, the configuration belongs to playback based cache replication. If playback_enabled is
not true, or not present at all, these parts of the gds_mysql role will just be ignored.
Apart from that, ll the parameters are mandatory. The parameters are the following:

- peers: Determines which node is replicating from which node. in the example above, test-db1.snc1 is
         playing back the streamed slowlog from test-db2.snc1 and test-db2.snc1 is playing back the
         streamed slowlog from test-db1.snc1. In a very typical scenario, you want to set up pairs like
         this. The member of these pairs can even be 2 slaves (remember this is not data replication, 
         the point is to reproduce the innodb buffer pool content of one node on an other.

- manage_mysql_slowlogd: When set to 1, the runit script managing playback also manages mysql_slowlogd.
                         Not needed when slowlogd is running continuously. When in doubt, set to 1.

- user: The mysql user percona-playback is going to connect with.

- password: The password for the mysql user percona-playback is going to connect with.

- schema: The schema on which the playback will happen. Percona-playback doesn't support playabck
          on multiple schemas.

- thread_pool_size: The size of percona-playback's thread pool, also determines the maximum degree 
                    of parallelism of the slow log replay.

- user_connection_threshold: The number of user level (application level) connections that has to be
                             present in order to consider the node active. If the node is considered
                             active, runit will start mysql_slowlogd, if the node is considered 
                             passive, runit will start percona-playback connecting to it's peer's
                             mysql_slowlogd.

- mysql_user_to_check: The mysql user to check to determine wether a node is active.

- playback_connection_timeout: if the youngest playback connection's idle time reaches this 
                               threshold, playabck is restarted automatically. In this case we 
                               assume that something is stuck, and we need the tail of the slow log replayed
                               anyway.

- mysql_slowlogd_port: The port mysql_slowlogd will listen on.

## Opertions

After the configuration and running the playbook, a runit service will appear on the host for the configured instance.

```
root@test-db1:/var/service/playback_gds_mysql_test01_test-db1.snc1_test-db2.snc1 # sv stat .
run: .: (pid 58154) 74910s; run: log: (pid 636) 78924s
```

It's log is in log/main/current. The run script of the service is and endless loop, which checks the machine state
every second. If the machine is active (mysql_user_to_check is connected more times than user_connection_threshold)
it will start mysql_slowlogd, otherwise it will start percona-playback. This state is checked and updated every second,
meaning that when the cluster fails over, the roles are changed immediately from the perspective of playback.
