#!/usr/bin/env ruby

require 'yaml'
require 'json'
require 'redis'
require 'logger'
require 'set'

$logger = Logger.new(STDOUT)
API_CACHE_DIR = '/var/groupon/raas/api_cache'

host = YAML.load_file('/var/tmp/host.yml')
clusters = host['params']['clusters'].keys
new_resque_web_dbs = {}

if host['params']['resque_web_dbs']
  resque_web_dbs = host['params']['resque_web_dbs']
  $used_ports = Set.new resque_web_dbs.map{|k,v| v['resque_web_port']}
else
  resque_web_dbs = {}
  $used_ports = Set.new
end

def next_available_port
  100.times do |i|
    candidate = 8100+i
    next if $used_ports.include?(candidate)
    $used_ports.add(candidate)
    return candidate
  end
  raise 'no available ports'
end

clusters.each do |cluster|
  cluster_dir = File.join(API_CACHE_DIR,cluster)
  dbs = JSON.parse IO.read(File.join(cluster_dir, 'dbs.json'))
  dbs.each do |db|
    hostname, port = db['endpoints'].first.values_at('dns_name', 'port')
    redis_endpoint = "#{hostname}:#{port}"
    if resque_web_dbs[db['name']] && resque_web_dbs[db['name']]['redis_endpoint'] == redis_endpoint
      $logger.info "already_in_hostfile cluster=#{cluster} dbname=#{db['name']}"
      next
    end
    next unless hostname.start_with?('redis-')
    conn = {
      host: hostname,
      port: port,
    }
    conn[:password] = db['authentication_redis_pass'] unless db['authentication_redis_pass'].empty?
    redis = Redis.new(conn)
    begin
      resque = redis.type('resque:queues') == 'set'
    rescue Redis::CommandError # normally when cluster-mode=on -> can't be resque
      next
    end
    namespaces = nil
    unless resque
      begin
        info = redis.info
        raise 'no keys info found' unless info['db0'] =~ /^keys=[0-9]+,/
        num_keys = info['db0'].split(',').first.split('=').last.to_i # keys=2371,expires=0,avg_ttl=0
        if num_keys > 0 && num_keys <= 200
          $logger.info "querying namespaces num_keys=#{num_keys} cluster=#{cluster} dbname=#{db['name']}"
          namespaces = redis.keys('resque:*:queues').map{|k| k.split(':')[1]}
          resque = true if namespaces.count > 0
        else
          $logger.info "assume unknown type num_keys=#{num_keys} cluster=#{cluster} dbname=#{db['name']}"
        end
      rescue
      end
    end
    if resque
      $logger.info "cluster=#{cluster} dbname=#{db['name']}"
      h = {
        'redis_endpoint' => redis_endpoint,
        'resque_web_port' => next_available_port,
      }
      h['namespace'] = (namespaces.count==1 ? namespaces.first : namespaces ) if namespaces
      new_resque_web_dbs[db['name']] = h
    end
  end
end
puts new_resque_web_dbs.to_yaml
