require 'resque-cleaner'

# The original source of this file is in /usr/local/etc/resque-web.rb
# This file is copied by /usr/local/etc/init.d/raas-resque-web, one for each resque-web
# Each copy will have the redis host in the name: /var/tmp/resque-web.<REDIS_HOST>.rb
# example: /var/tmp/resque-web.redis-13000.us.raas-test1.grpn.rb
redis_host = File.basename(__FILE__)['resque-web.'.size..-4]
redis_port = redis_host.split('.').first.split('-').last.to_i
conn = {
  host: redis_host,
  port: redis_port,
}

# Get redis password
cluster = redis_host[redis_host.index('.')+1..-1]
require 'json'
dbs = JSON.parse(IO.read("/var/groupon/raas/api_cache/#{cluster}/dbs.json"))
db = dbs.detect{|db| db['endpoints'].first['dns_name'] == redis_host}
conn[:password] = db['authentication_redis_pass'] if db['authentication_redis_pass'] && !db['authentication_redis_pass'].empty?

# remember the namespace in case it was set
namespace = Resque.redis.namespace

require 'redis'
Resque.redis = Redis.new(conn)
Resque.redis.namespace = namespace