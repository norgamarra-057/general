require 'open-uri'
require 'yaml'

raise "unknown ENV['env'], should be prod or staging" if !['prod', 'staging'].include?(ENV['env'])

url = 'https://raw.github.groupondev.com/data/raas_terraform_modules/master/source/redis_instances.yml'
web_contents  = open(url) {|f| f.read }
instances = YAML.load web_contents
resque_instances = instances.select{|k,v| v['resque']}
resque_instances.each do |k,v|
  ns = v['resque_ns'] ? ":#{v['resque_ns']}" : ''
  puts "#{k}--redis.#{ENV['env']}:6379/resque#{ns}"
end
