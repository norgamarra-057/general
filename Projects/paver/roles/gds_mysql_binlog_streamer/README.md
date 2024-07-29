Streams binlog from a remote mysql server. Example for mondatory parameters:

``` 
  roles:
  - { role: gds_mysql_binlog_streamer,
      stream_name: test_binlog_stream,
      local_binlog_path: /var/groupon/percona/test_binlog_stream,
      from_host: test-db3.snc1 }
```

Mondatory parameters:
- stream_name: the name of the binary log stream
- local_binlog_path: where to save binlogs locally
- from_host: hostname to stream the binlog from

Optional parameters:
- from_port: port for the remote server
- from_utility_user: remote utility user
- from_utility_password: remote utility password
- from_replication_user: remote replication user 
- from_replication_password: remote replication password

The remote_utility_user and remote_replication_user and their password's default are suitable for streaming binlog from roller based machines. The stream is identified by it's name. From the example above, the following service will be created:

```
  [root@gds-snc1-db001m1 /var/service]# sv stat gds-binlog-streamer_test_binlog_stream/
  run: gds-binlog-streamer_test_binlog_stream/: (pid 33266) 338s; run: log: (pid 33265) 338s
```
