require 'set'

# Expected clusters_info structure:
# clusters:
#   us.raas-redis-prod.grpn:
#     dbs:
#       redis-10862.us.raas-redis-prod.grpn:
#         name: pablotest3
#         port: 10862
#       redis-12538.us.raas-redis-prod.grpn:
#         name: pablotest2
#         port: 12538
#     pagers:
#     - pablo@groupon.com
#     non_pagers:
#     - pablo@groupon.com
#   us.raas-badges-prod.grpn:
#     pagers:
#     - darwin-alerts@groupon.com
#     non_pagers:
#     - pablo@groupon.com
#     - relevance-runtime@groupon.com
#     dbs:
#       redis-19328.us.raas-badges-prod.grpn:
#         name: Badges
#         port: 19328

class RLECMons

  def initialize
    # default values, can be overwritten:
    @clusters_thresholds = {
      'license_days_to_expiration' => '60:30',
      'shards_usage_pct' => '80:90',
      'db_mem_overcommit_pct' => '70:80',
      'db_cputime_sec' => '0.8:0.9',
      'db_connection_time_open' => '1:2',
      'db_connection_time_command' => '2:3',
      'db_ns_nodes' => '1:0',
      'db_resolv_time' => '0.1:0.2',
      'db_used_memory_warning_pct' => 85,
      'db_used_memory_critical_pct' => 90,
      'db_evicted_objects' => '1:1000000000', # warn only
      'db_egress_bytes' => '33554432:67108864',
      'db_ingress_bytes' => '33554432:67108864',
    }
  end

  def create_rlec_mons(clusters_info, clusters_thresholds)
    @clusters_thresholds.merge!(clusters_thresholds) if clusters_thresholds
    monitors = {}
    clusters_info.sort.each do |cluster_name, cluster_info|
      notify_arr, notify_arr_no_pagers = create_notify_arrays(cluster_info['pagers'], cluster_info['non_pagers'])
      mons = cluster_mons(cluster_name, notify_arr, notify_arr_no_pagers)
      mons.each do |k,v|
        monitors[k] ||= []
        monitors[k] << v
      end
      cluster_info['dbs'].sort.each do |dbhostname, dbinfo|
        db_pagers = begin dbinfo['pagers'][0..-1] rescue cluster_info['pagers'] end
        db_non_pagers = begin dbinfo['non_pagers'][0..-1] rescue cluster_info['non_pagers'] end
        notify_arr, notify_arr_no_pagers = create_notify_arrays(db_pagers, db_non_pagers)
        mons = db_mons(cluster_name, dbhostname, dbinfo, notify_arr, notify_arr_no_pagers)
        mons.each do |k,v|
          monitors[k] ||= []
          monitors[k] << v
        end
      end
    end
    monitors
  end

  private

  def create_notify_arrays(pagers, non_pagers)
    notify_arr = []
    notify_arr_no_pagers = []
    non_pagers.each do |email|
      notify = { email => {'notify_on' => ['critical', 'unknown', 'warning', 'ok']}}
      notify_arr << notify
      notify_arr_no_pagers << notify
    end
    pagers.each do |email|
      notify = { email => {'notify_on' => ['critical', 'unknown']}}
      notify_arr << notify
    end
    return notify_arr, notify_arr_no_pagers
  end

  def cluster_mons(cluster_name, notify_arr, notify_arr_no_pagers)
    # cluster_name ex: 'us.raas-badges-prod.grpn'
    {
      'rlec_cluster_alerts' => {
          'max_check_attempts' => 3,
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_cluster_alerts',
          'shell_command' => "/usr/local/libexec/redislabs/check_cluster_alerts --clustername=#{cluster_name} --thresholds=cluster_even_node_count=0.1:2,cluster_ram_overcommit=0.1:2,cluster_*=0",
          'spoof_host' => "nil:#{cluster_name}"
      },
      'rlec_license' => {
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_license',
          'shell_command' => "/usr/local/libexec/redislabs/check_license --clustername=#{cluster_name} --thresholds=days_to_expiration=#{@clusters_thresholds['license_days_to_expiration']}",
          'spoof_host' => "nil:#{cluster_name}"
      },
      'rlec_license_shards_usage' => {
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_license_shards_usage',
          'shell_command' => "/usr/local/libexec/redislabs/check_cluster_shards_usage --clustername=#{cluster_name} --thresholds=shards_usage_pct=#{@clusters_thresholds['shards_usage_pct']}",
          'spoof_host' => "nil:#{cluster_name}"
      },
      'rlec_mem_overcommit' => {
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_mem_overcommit',
          'shell_command' => "/usr/local/libexec/redislabs/check_mem_overcommit --clustername=#{cluster_name} --thresholds=commit_pct=#{@clusters_thresholds['db_mem_overcommit_pct']}",
          'spoof_host' => "nil:#{cluster_name}"
      },
      'rlec_nodes_alerts' => {
          'max_check_attempts' => 3,
          'notify' => notify_arr,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_nodes_alerts',
          'shell_command' => "/usr/local/libexec/redislabs/check_nodes_alerts --clustername=#{cluster_name} --thresholds=n*_node_failed=0,n*=0.1:2",
          'spoof_host' => "nil:#{cluster_name}"
      },
      'rlec_changes_cluster' => {
          'max_check_attempts' => 1,
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_changes_cluster',
          'shell_command' => "/usr/local/libexec/redislabs/check_changes_cluster --clustername=#{cluster_name}",
          'spoof_host' => "nil:#{cluster_name}"
      },
      'rlec_changes_dbs' => {
          'max_check_attempts' => 1,
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_changes_dbs',
          'shell_command' => "/usr/local/libexec/redislabs/check_changes_dbs --clustername=#{cluster_name}",
          'spoof_host' => "nil:#{cluster_name}"
      },
      'rlec_quorum_node' => {
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_quorum_node',
          'shell_command' => "/usr/local/libexec/redislabs/check_quorum_node --clustername=#{cluster_name}",
          'spoof_host' => "nil:#{cluster_name}"
      },
      'rlec_resolv' => {
          'notify' => notify_arr,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_resolv',
          'shell_command' => "/usr/local/libexec/redislabs/check_resolution --clustername=#{cluster_name} --thresholds=ns_nodes=#{@clusters_thresholds['db_ns_nodes']},resolv_time*=#{@clusters_thresholds['db_resolv_time']}",
          'spoof_host' => "nil:#{cluster_name}"
      },
      'rlec_multi_proxy_nodes' => {
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_multi_proxy_nodes',
          'shell_command' => "/usr/local/libexec/redislabs/check_multi_proxy_nodes --clustername=#{cluster_name}",
          'spoof_host' => "nil:#{cluster_name}"
      },
      'rlec_db_shards_balance' => {
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_db_shards_balance',
          'shell_command' => "/usr/local/libexec/redislabs/check_db_shards_balance --clustername=#{cluster_name}",
          'spoof_host' => "nil:#{cluster_name}"
      },
      'rlec_endpoint_shard_distance' => {
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_endpoint_shard_distance',
          'shell_command' => "/usr/local/libexec/redislabs/check_endpoint_shard_distance --clustername=#{cluster_name}",
          'spoof_host' => "nil:#{cluster_name}"
      },
      'rlec_shard_syncs' => {
          'max_check_attempts' => 1,
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_shard_syncs',
          'shell_command' => "/usr/local/libexec/redislabs/check_shard_syncs --clustername=#{cluster_name}",
          'spoof_host' => "nil:#{cluster_name}"
      },
      'rlec_aof_params' => {
          'max_check_attempts' => 3,
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_aof_params',
          'shell_command' => "/usr/local/libexec/redislabs/check_aof_params --clustername=#{cluster_name}",
          'spoof_host' => "nil:#{cluster_name}"
      },
      'rlec_dbs_replication' => {
          'max_check_attempts' => 3,
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_dbs_replication',
          'shell_command' => "/usr/local/libexec/redislabs/check_dbs_replication --clustername=#{cluster_name}",
          'spoof_host' => "nil:#{cluster_name}"
      },
      'rlec_shards_size' => {
          'max_check_attempts' => 3,
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_shards_size',
          'shell_command' => "/usr/local/libexec/redislabs/check_shards_size --clustername=#{cluster_name}",
          'spoof_host' => "nil:#{cluster_name}"
      },
      'rlec_rladmin_status' => {
          'max_check_attempts' => 3,
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_rladmin_status',
          'shell_command' => "/usr/local/libexec/redislabs/check_rladmin_status --clustername=#{cluster_name}",
          'spoof_host' => "nil:#{cluster_name}"
      },
    }
  end

  def db_mons(cluster_name, dbhostname, dbinfo, notify_arr, notify_arr_no_pagers)
    dbname = dbinfo['name']
    dbid = dbinfo['uid']
    dbport = dbinfo['port']
    memory_size = dbinfo['memory_size']
    # cluster_name ex: 'us.raas-badges-prod.grpn'
    # dbhostname ex: redis-19328.us.raas-badges-prod.grpn
    # dbname ex: 'Badges'
    used_memory_w = (@clusters_thresholds['db_used_memory_warning_pct']*memory_size/100).to_i
    used_memory_c = (@clusters_thresholds['db_used_memory_critical_pct']*memory_size/100).to_i
    if dbinfo['mem_alerts_enabled']
      mem_threshold = ",used_memory=#{used_memory_w}:#{used_memory_c}"
      # We've seen dbs not alerting on memory usage, but evicting (DATA-4246)
      eviction_threshold = ",evicted_objects=#{@clusters_thresholds['db_evicted_objects']}"
    else
      mem_threshold = ""
      eviction_threshold = ""
    end
    backup_threshold = dbinfo['backup_alerts_enabled'] ? "bdb_backup_delayed=0.1:2," : "" # warn only
    if dbinfo['latency_threshold']
      latency_threshold = "#{dbinfo['latency_threshold']*0.8}:#{dbinfo['latency_threshold']}"
    else
      latency_threshold = '40000:50000' # microseconds
    end

    {
      'rlec_db_alerts' => {
          'max_check_attempts' => 3,
          'notify' => notify_arr,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_db_alerts',
          'shell_command' => "/usr/local/libexec/redislabs/check_db_alerts --clustername=#{cluster_name} --dbname=#{dbname} --thresholds=#{backup_threshold}bdb_high_throughput=0.1:2,bdb_*=0",
          'spoof_host' => "nil:#{dbname.downcase}.#{cluster_name}"
      },
      'rlec_db_cputime' => {
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_db_cputime',
          'shell_command' => "/usr/local/libexec/redislabs/check_db_cputime --clustername=#{cluster_name} --dbname=#{dbname} --thresholds=cputime_*_sec=#{@clusters_thresholds['db_cputime_sec']}",
          'spoof_host' => "nil:#{dbname.downcase}.#{cluster_name}"
      },
      'rlec_db_redisconn' => {
          'notify' => notify_arr,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_db_redisconn',
          'shell_command' => "/usr/local/libexec/redislabs/check_connection --clustername=#{cluster_name} --dbname=#{dbname} --host=#{dbhostname} --port=#{dbport} --thresholds=time_open=#{@clusters_thresholds['db_connection_time_open']},time_command=#{@clusters_thresholds['db_connection_time_command']}",
          'spoof_host' => "nil:#{dbname.downcase}.#{cluster_name}"
      },
      'rlec_db_stats' => {
          'notify' => notify_arr,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_db_stats',
          'shell_command' => "/usr/local/libexec/redislabs/check_db_stats --clustername=#{cluster_name} --dbname=#{dbname} --thresholds=avg_read_latency=#{latency_threshold},avg_write_latency=#{latency_threshold}#{mem_threshold}#{eviction_threshold},egress_bytes=#{@clusters_thresholds['db_egress_bytes']},ingress_bytes=#{@clusters_thresholds['db_ingress_bytes']}",
          'spoof_host' => "nil:#{dbname.downcase}.#{cluster_name}"
      },
      'rlec_db_endpoints_stats' => {
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_db_endpoints_stats',
          'shell_command' => "/usr/local/libexec/redislabs/check_db_endpoints_stats --clustername=#{cluster_name} --dbname=#{dbname}",
          'spoof_host' => "nil:#{dbname.downcase}.#{cluster_name}"
      },
      'rlec_changes_db_endpoints' => {
          'max_check_attempts' => 1,
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_changes_endpoints',
          'shell_command' => "/usr/local/libexec/redislabs/check_changes_endpoints --dbname=#{dbname} --clustername=#{cluster_name}",
          'spoof_host' => "nil:#{dbname.downcase}.#{cluster_name}"
      },
      'rlec_changes_db_shards' => {
          'max_check_attempts' => 1,
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_changes_shards',
          'shell_command' => "/usr/local/libexec/redislabs/check_changes_shards --dbname=#{dbname} --clustername=#{cluster_name}",
          'spoof_host' => "nil:#{dbname.downcase}.#{cluster_name}"
      },
      'rlec_resque' => {
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_resque',
          'shell_command' => "/usr/local/libexec/redislabs/check_resque --clustername=#{cluster_name} --dbname=#{dbname} --host=#{dbhostname} --port=#{dbport}",
          'spoof_host' => "nil:#{dbname.downcase}.#{cluster_name}"
      },
      'rlec_info' => {
          'notify' => notify_arr_no_pagers,
          'run_every' => 60,
          'runbook_url' => 'https://confluence.groupondev.com/display/RED/redislabs+Manual#redislabsManual-nagiosalert-rlec_info',
          'shell_command' => "/usr/local/libexec/redislabs/check_info --clustername=#{cluster_name} --dbname=#{dbname} --host=#{dbhostname} --port=#{dbport}",
          'spoof_host' => "nil:#{dbname.downcase}.#{cluster_name}"
      },
    }
  end

end
