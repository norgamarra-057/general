#!/usr/bin/env ruby

USAGE = "usage: #{$0} <cluster> <dbname>"

raise USAGE unless ARGV.size==2
$cluster = ARGV[0] # ex: us.raas-test1.grpn
$dbname = ARGV[1] # ex: test-rebalance-pablo
raise USAGE unless $cluster && $cluster.include?('.') && $dbname && !$dbname.include?('.')

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../lib/')
require 'placement.rb'

require 'json'
json_path = "/var/groupon/raas/api_cache/#{$cluster}/rladmin_status.json"
rladmin_status = JSON.parse IO.read(json_path)
nodes = []
rladmin_status['CLUSTER NODES'].each do |h|
  next if h['SHARDS']=='0/0' # quorum node
  nodes << [h['NODE:ID'], h['RACK-ID']]
end
raise "no nodes found in #{json_path}" if nodes.empty?

shards = []
rladmin_status['SHARDS'].each do |h|
  next unless h['NAME']==$dbname
  shards << [h['ID'], h['NODE'], h['ROLE'], h['SLOTS']]
end
raise "no shards found for db #{$dbname} in #{json_path}" if shards.empty?

placement = Placement.new($dbname, nodes, shards)
move = placement.calculate_move
placement.add_migration_commands(move)

# "migration_commands" are arrays of commands per slot
# We can run all the first elements in batch,
#  then the second elements, and so on
move.map{|k,v| v[:migration_commands].size}.max.times do |i|
  puts "================ BATCH ##{i+1} ==========="
  move.each_value do |v|
    next if v[:migration_commands].empty?
    puts v[:migration_commands][i] if v[:migration_commands][i]
  end
  puts "================ WAIT until all shards are in sync..."
end

shards_per_node = {}
rladmin_status['SHARDS'].each do |h|
  next unless h['NAME']==$dbname
  shards_per_node[h['NODE']] ||= {'master' => 0, 'slave' => 0}
  shards_per_node[h['NODE']][h['ROLE']] += 1
end
puts "\nCurrent state:"
shards_per_node.each do |n, s|
  puts "#{n} #{s}"
end
