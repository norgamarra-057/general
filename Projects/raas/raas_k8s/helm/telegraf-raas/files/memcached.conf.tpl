[[inputs.memcached]]
logfilepath = "/var/groupon/logs/telegraf_memcached.log"
servers = [SERVERS]
fielddrop = ["accepting_conns", "auth_cmds", "auth_errors", "cas_badval", "conn_yields", "connection_structures", "hash_bytes", "hash_is_expanding", "hash_power_level", "total_connections", "total_items"]
