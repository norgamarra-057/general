#!/usr/bin/env ruby

require 'logger'
require 'fileutils'
require 'yaml'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../lib/')
require 'rlec_mons'
require 'db_info'
require 'nagios_info'

RLEC_MONS_FILE = "/var/groupon/raas_mon/rlec_mons.json"
HOST_FILE = '/var/tmp/host.yml'
TOUCH_FILE = '/tmp/touched_by_raas_mon_updater_when_success'

def load_last_rlec_mons
  JSON.parse IO.read(RLEC_MONS_FILE)
rescue
  nil
end

def save_last_rlec_mons(rlec_mons)
  tmp_path = "#{RLEC_MONS_FILE}.#{$$}"
  $logger.info "event=writing_tmp_output path=#{tmp_path}"
  IO.write(tmp_path, JSON.pretty_generate(rlec_mons))
  $logger.info "event=moving_tmp_to_permanent path=#{RLEC_MONS_FILE}"
  FileUtils.mv tmp_path, RLEC_MONS_FILE
end

def load_current_host_file
  $logger.info 'event=load_current_host_file'
  host = YAML.load_file(HOST_FILE)
  cluster_params = host['params']['clusters']
  raise "invalid host file, cannot find params.clusters section" if !cluster_params.is_a?(Hash) || cluster_params.empty?
  host
end

# Example structure of clusters_info:
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
#     ...
def add_db_info(clusters_info)
  clusters_info.each do |cluster_name, cluster_info|
    dbs = DBInfo.new.get_dbs(cluster_name)
    # Don't just overwrite, there may be some info defined per db on hostfile,
    # like for example pagers and non_pagers
    cluster_info['dbs'] ||= {}
    dbs.each do |dbhostname, dbinfo|
      cluster_info['dbs'][dbhostname] ||= {}
      cluster_info['dbs'][dbhostname].merge!(dbinfo)
    end
  end
end

# MAIN

$logger = Logger.new(STDOUT)
begin
  $logger.info "event=start"
  host = load_current_host_file
  clusters_info = host['params']['clusters']
  clusters_thresholds =  host['params']['clusters_thresholds']
  add_db_info(clusters_info)
  rlec_mons = RLECMons.new.create_rlec_mons(clusters_info, clusters_thresholds)
  rlec_mons_before = load_last_rlec_mons
  if rlec_mons_before && rlec_mons_before == rlec_mons
    $logger.info "event=no_changes"
  else
    host['monitors'] = {} unless host['monitors']
    host['monitors'].merge! rlec_mons
    NagiosInfo.new(host).save
    save_last_rlec_mons(rlec_mons)
  end
  $logger.info "event=done"
  FileUtils.touch TOUCH_FILE
rescue
  $logger.error $!
end
