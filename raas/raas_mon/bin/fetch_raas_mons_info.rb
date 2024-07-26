#!/usr/bin/env ruby

require 'open-uri'
require 'yaml'
require 'json'
require 'set'
require 'fileutils'
require 'erb'
require 'logger'

PERSISTENCE = '/var/groupon/raas_mon'
HOST_FILE = '/var/tmp/host.yml'

def fetch_raas_mons_hostfiles(raas_mons)
  hostfiles = {}
  raas_mons.each do |raas_mon|
    url = "http://#{raas_mon}/host.yml"
    $logger.info "fetch=#{url}"
    hostfiles[raas_mon] = YAML.load(open(url).read)
  end
  hostfiles
end

def fetch_rladmin_status_by_cluster(hostfiles)
  rladmin_status_by_cluster = {}
  hostfiles.each do |raas_mon, host|
    clusters = host['params']['clusters'].keys
    clusters.each do |cluster|
      url = "http://#{raas_mon}/raas_info/#{cluster}/rladmin_status.json"
      $logger.info "fetch=#{url}"
      rladmin_status_by_cluster[cluster] = JSON.parse(open(url).read)
    end
  end
  rladmin_status_by_cluster
end

def fetch_dbs_by_hostname(hostfiles)
  dbs_by_hostname = {}
  hostfiles.each do |raas_mon, host|
    clusters = host['params']['clusters'].keys
    clusters.each do |cluster|
      colo = get_colo_from_cluster(cluster)
      env = get_env_from_cluster(cluster)
      url = "http://#{raas_mon}/raas_info/#{cluster}/dbs_clean.json"
      $logger.info "fetch=#{url}"
      rlec_db_info = JSON.parse(open(url).read)
      rlec_db_info.each do |h|
        endpoint = h['endpoints'].first
        h['cluster'] = cluster
        h['colo'] = colo
        h['env'] = env
        h['hostname'] = endpoint['dns_name']
        dbs_by_hostname[endpoint['dns_name']] = h
      end
    end
  end
  dbs_by_hostname
end

def add_resque_endpoints(dbs_by_hostname, hostfiles)
  hostfiles.each do |raas_mon, host|
    unless host['params']['resque_web_dbs']
      $logger.info "params.resque_web_dbs=nil"
      next
    end
    host['params']['resque_web_dbs'].each do |dbname, v|
      hostname = v['redis_endpoint'].split(':').first
      h = dbs_by_hostname[hostname]
      unless h
        $logger.info "redis_host_not_found=#{hostname} raas_mon=#{raas_mon}"
        next
      end
      h['resque_web'] = "http://#{raas_mon}:#{v['resque_web_port']}"
    end
  end
end

def persist_info(dbs_by_hostname)
  # maybe useful to fetch:
  atomic_write('dbs_by_hostname.json', JSON.pretty_generate(dbs_by_hostname))
  # create one html file with dbs sorted by cluster and
  # another with dbs sorted by name
  tpl_path = File.join(File.dirname(__FILE__), '../toolstrap/dbs.erb')
  template = IO.read(tpl_path)
  @dbs = dbs_by_hostname.values
  atomic_write('dbs1.html', ERB.new(template).result(binding))
  @dbs = @dbs.sort_by{|h| h['name']}
  atomic_write('dbs2.html', ERB.new(template).result(binding))
end

def atomic_write(filename, data)
  persistence_path = File.join(PERSISTENCE, filename)
  $logger.info "atomic_write=#{persistence_path}"
  IO.write("#{persistence_path}.tmp", data)
  FileUtils.mv("#{persistence_path}.tmp", persistence_path)
end

def get_colo_from_cluster(cluster)
  colo = cluster.split('.').first
  colo = 'snc1' if (colo == 'us')
  colo = 'dub1' if (colo == 'eu')
  colo
end

def get_env_from_cluster(cluster)
  env = 'test'
  env = 'prod' if cluster.end_with?('-prod.grpn')
  env = 'staging' if cluster.end_with?('-staging.grpn')
  env
end

$logger = Logger.new(STDOUT)
begin
  host = YAML.load_file(HOST_FILE)
  raas_mons = host['params']['raas_mons']
  if raas_mons
    hostfiles = fetch_raas_mons_hostfiles(raas_mons)
    rladmin_status_by_cluster = fetch_rladmin_status_by_cluster(hostfiles)
    atomic_write('rladmin_status_by_cluster.json', JSON.pretty_generate(rladmin_status_by_cluster))
    # create raas-info web page
    dbs_by_hostname = fetch_dbs_by_hostname(hostfiles)
    add_resque_endpoints(dbs_by_hostname, hostfiles)
    persist_info(dbs_by_hostname)
  else
    $logger.info 'host.params.raas_mons=nil'
  end
  FileUtils.touch '/tmp/touched_by_fetch_raas_mons_info_when_run_successfully'
rescue
  $logger.error $!
end
