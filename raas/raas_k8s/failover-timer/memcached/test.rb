require 'dalli-elasticache'
require 'logger'

NUM_KEYS = 1000; # the more NUM_KEYS the more likely they'll be spread across all memcached nodes

$stdout.sync = true # flush after every log message
$logger = Logger.new(STDOUT)

# https://github.com/petergoldstein/dalli
options = {
  socket_timeout: 1,
  socket_max_failures: 1,
  down_retry_delay: 1,
  raise_errors: true,
  expires_in: 60,
}
# https://github.com/ktheory/dalli-elasticache
elasticache = Dalli::ElastiCache.new(ENV['ENDPOINT'], options)

dc = elasticache.client
loop do
  begin
    NUM_KEYS.times do |i|
      # actually creates a connection to memcached
      dc.get("foo#{i}")
    end
    $logger.info "elasticache servers: #{elasticache.servers}"
  rescue
    $logger.error($!.to_s)
  end
  sleep 1
end
