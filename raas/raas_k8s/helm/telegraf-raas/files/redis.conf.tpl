[[inputs.redis]]
logfilepath = "/var/groupon/logs/telegraf_redis.log"
servers = [SERVERS]
fieldpass = ["keys", "expires", "avg_ttl", "count", "resque*", "keyspace_hits", "keyspace_misses", "latency*", "cmdstat*", "slowlog*", "client_recent_max_output_buffer", "clients", "evicted_keys", "expired_keys", "maxmemory", "uptime", "used_cpu_sys", "used_cpu_user", "used_memory", "used_memory_dataset", "total_commands_processed", "total_connections_received", "total_net_input_bytes", "total_net_output_bytes", "info_slots_fail", "info_slots_pfail", "nodes_fail", "nodes_master", "nodes_slave"]