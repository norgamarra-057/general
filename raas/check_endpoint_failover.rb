#!/usr/bin/env ruby

# DATA-4105
# Automate periodic failovers of UAT/Staging instances
#
# Usage:
# sudo -E ./check_endpoint_failover.rb > clients1.json
# # run failover commands from logger output
# # wait 1 minute
# sudo -E ./check_endpoint_failover.rb > clients2.json
# vimdiff clients*

require 'set'
require 'logger'
require 'json'

def rladmin_status_extra_all
  status_output = %x[TERM="" /opt/redislabs/bin/rladmin status extra all]
  status = {}
  h1 = h2 = nil
  status_output.each_line do |line|
    line.strip!
    next if line.empty?
    if line[0] =~ /[A-Z]/ # header line
      if line.end_with?(':') # Ex "SHARDS:"
        h1 = line[0..-2]
        status[h1] = []
      else
        h2 = line.split # Ex "DB:ID       NAME    ID         NODE    ROLE    SLOTS       USED_MEMORY   STATUS"
        h2.delete('EXTERNAL_ADDRESS') if h1 == 'CLUSTER NODES' # N/A at Groupon, bugfix (DATA-3473)
      end
    else
      # Ex "db:1        Badges  redis:1    node:3  slave   1-512       20.68MB       OK"
      line[0]='' if line.start_with?('*') if h1 == 'CLUSTER NODES' # may have a star at the beginning of the line indicating the current node
      status[h1].push(Hash[h2.zip(line.split)])
    end
  end
  status
end

def raise_status_errors(status)
  status['CLUSTER NODES'].each do |node|
    raise "node=#{node['NODE:ID']} STATUS=#{node['STATUS']}" unless node['STATUS'] == "OK"
  end
  status['DATABASES'].each do |db|
    raise "db=#{db['NAME']} EXEC_STATE=#{db['EXEC_STATE']}" unless db['EXEC_STATE'] == "N/A"
    raise "db=#{db['NAME']} EXEC_STATE_MACHINE=#{db['EXEC_STATE_MACHINE']}" unless db['EXEC_STATE_MACHINE'] == "N/A"
  end
  status['ENDPOINTS'].each do |endpoint|
    raise "endpoint=#{endpoint['NAME']} WATCHDOG_STATUS=#{endpoint['WATCHDOG_STATUS']}" unless endpoint['WATCHDOG_STATUS'] == "OK"
  end
  status['SHARDS'].each do |shard|
    raise "shard=#{shard['NAME']} STATUS=#{shard['STATUS']}" unless shard['STATUS'] == "OK"
    raise "shard=#{shard['NAME']} WATCHDOG_STATUS=#{shard['WATCHDOG_STATUS']}" unless shard['WATCHDOG_STATUS'] == "OK"
  end
end

def get_dbs_info(status)
  dbs_info = {}
  status['DATABASES'].each do |db|
    dbs_info[db['DB:ID']] = {
      'name' => db['NAME'],
      'endpoint' => db['ENDPOINT'],
      'type' => db['TYPE'],
    }
  end
  status['ENDPOINTS'].each do |endpoint|
    dbs_info[endpoint['DB:ID']]['endpoint_node'] = endpoint['NODE']
    dbs_info[endpoint['DB:ID']]['endpoint_id'] = endpoint['ID']
  end
  status['SHARDS'].each do |shard|
    dbs_info[shard['DB:ID']]['shard_nodes'] = Set.new() unless dbs_info[shard['DB:ID']]['shard_nodes']
    dbs_info[shard['DB:ID']]['shard_nodes'].add shard['NODE']
  end
  dbs_info
end

def clients(endpoint, password)
  clients = Set.new
  host, port = endpoint.split(':')
  pass = password.empty? ? "" : "-a #{password}"
  client_list_output = %x[/opt/redislabs/bin/redis-cli #{pass} -h #{host} -p #{port} client list]
# echo stats | nc localhost 11211 | grep curr_conn
  client_list_output.each_line do |line|
    addr_part = line.split.detect{|p| p.start_with?('addr=')}
    clients.add addr_part.split('=').last.split(':').first
  end
  clients
end

def failover(db_info)
  endpoint = db_info['endpoint_id'].split(':')[1..-1].join(':') # ex: endpoint:2:1 -> 2:1
  node_new = (db_info['shard_nodes'] - [db_info['endpoint_node']]).first.split(':').last
  node_old = db_info['endpoint_node'].split(':').last
  cmd1 = "sudo /opt/redislabs/bin/rladmin bind endpoint #{endpoint} add #{node_new}"
  cmd2 = "sudo /opt/redislabs/bin/rladmin bind endpoint #{endpoint} remove #{node_old}"
  $logger.info "db=#{db_info['name']} failover_cmd: #{cmd1} && #{cmd2}"
  # %x[TERM="" #{cmd}]
end

def get_dbs_from_api
  res = {}
  data = JSON.parse %x[/usr/local/bin/curl -sk -u guest@groupon.com:guest https://localhost:9443/v1/bdbs]
  data.each do |d|
    res["db:#{d['uid']}"] = d
  end
  res
end

$logger = Logger.new(STDERR)
status = rladmin_status_extra_all
raise_status_errors(status)
dbs_info = get_dbs_info(status)

dbs_info.each do |db_id, db_info|
  failover(db_info)
end

dbs_api = get_dbs_from_api

clients = {}
dbs_info.each do |db_id, db_info|
  unless db_info['type']=='redis'
    $logger.warn "skip_get_clients=#{db_info['name']} type=#{db_info['type']}"
    next
  end
  password = dbs_api[db_id]['authentication_redis_pass']
  $logger.info "get_clients=#{db_info['name']}"
  clients[db_info['endpoint']] = {
    'name' => db_info['name'],
    'clients' => clients(db_info['endpoint'], password).to_a.sort,
  }
end

puts JSON.pretty_generate(clients)
