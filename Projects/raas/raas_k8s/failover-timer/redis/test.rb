require 'redis'
require 'logger'

NUM_KEYS = 1000; # the more NUM_KEYS the more likely they'll be spread across all memcached nodes

$stdout.sync = true # flush after every log message
$logger = Logger.new(STDOUT)

# https://github.com/redis/redis-rb
options = {
  timeout: 1,
}
r = nil
begin
  o = options.clone(); o[:cluster] = ["redis://#{ENV['ENDPOINT']}"]
  r = Redis.new(o)
  $logger.info "connected to redis cluster #{o}"
rescue Redis::CannotConnectError
  o = options.clone(); o[:url] = "redis://#{ENV['ENDPOINT']}"
  r = Redis.new(o)
  $logger.info "connected to stand-alone redis #{o}"
end

error_time = nil
loop do
  begin
    NUM_KEYS.times do |i|
      r.get("foo#{i}")
    end
    $logger.info "recovered after #{(Time.now - error_time).round(3)}s" if error_time
    $logger.info "all good"
    error_time = nil
  rescue
    unless error_time
      $logger.error($!.to_s)
      error_time = Time.now
    end
  end
  sleep 1
end
