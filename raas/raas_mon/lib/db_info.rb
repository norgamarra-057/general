require 'json'
require 'yaml'

class DBInfo

  API_CACHE_DIR = '/var/groupon/raas/api_cache'

  def get_dbs(cluster_name)
    $logger.info "get_dbs=#{cluster_name}"
    rlec_db_info = get_rlec_db_info(cluster_name)
    dbs = {}
    rlec_db_info.each do |h|
      endpoint = h['endpoints'].first
      dbhostname = endpoint['dns_name']
      dbinfo = {}
      dbinfo['name'] = h['name']
      dbinfo['uid'] = h['uid']
      dbinfo['port'] = endpoint['port']
      dbinfo['memory_size'] = h['memory_size']
      dbinfo['mem_alerts_enabled'] = h['alert_info']['bdb_size']['enabled']
      dbinfo['backup_alerts_enabled'] = h['alert_info']['bdb_backup_delayed']['enabled']
      dbinfo['latency_threshold'] = h['alert_info']['bdb_high_latency']['threshold'].to_i if h['alert_info']['bdb_high_latency']['enabled']
      dbs[dbhostname] = dbinfo
    end
    dbs
  end

  private

  def get_rlec_db_info(cluster_name)
    rlec_db_info = JSON.parse IO.read(File.join(API_CACHE_DIR,cluster_name,'dbs.json'))
    alert_info = JSON.parse IO.read(File.join(API_CACHE_DIR,cluster_name,'dbs_alerts.json'))
    rlec_db_info.each do |dbinfo|
      dbinfo['alert_info'] = alert_info[dbinfo['uid'].to_s]
    end
    rlec_db_info
  end

end