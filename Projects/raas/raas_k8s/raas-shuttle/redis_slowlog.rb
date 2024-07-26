# [[87283, 1442412746, 18052, ["hincrby", "191320:2015-09-16", "2015-09-16T13:39:00.000Z", "1"]], [87282, 1442411252, 22037, ["setex", "sifi_session:da34d588e031730b84a0462538022c60", "604800", "\u0004\b{\u0000"]], [87281, 1442410521, 81575, ["scan", "0", "MATCH", "CampaignStatistic:*", "COUNT", "1000"]], [87280, 1442409284, 12309, ["hincrby", "167569:2015-09-16", "2015-09-16T12:57:00.000Z", "1"]], [87279, 1442409279, 11073, ["hincrby", "163562:2015-09-16", "2015-09-16T12:55:00.000Z", "1"]], [87278, 1442409206, 14440, ["hincrby", "163558:2015-09-16", "2015-09-16T12:40:00.000Z", "1"]], [87277, 1442409198, 14750, ["hincrby", "187840:2015-09-16", "2015-09-16T12:34:00.000Z", "1"]], [87276, 1442409180, 11376, ["hincrby", "127478:2015-09-16", "2015-09-16T12:07:00.000Z", "1"]], [87275, 1442405559, 18445, ["hincrby", "182934:2015-09-16", "2015-09-16T11:13:00.000Z", "1"]], [87274, 1442405558, 57467, ["hincrby", "17342:2015-09-16", "2015-09-16T11:03:00.000Z", "1"]]]
require 'redis'

class Entry
  attr_reader :log_number, :unix_timestamp, :microseconds, :command, :full_command
  def initialize(raw_data)
    @log_number = raw_data[0]
    @unix_timestamp = raw_data[1]
    @microseconds = raw_data[2]
    @command = raw_data[3].first
    @full_command = raw_data[3].join(' ')
  end

  def milliseconds
    @microseconds / 1000.0
  end

  def time
    Time.at @unix_timestamp
  end
end

if ARGV.length < 1 || ARGV.length > 2
  puts "redis_slowlog.rb [:password@]<host>[:<port>] [entries]"
  puts "entries defaults to 128"
  exit
end
address = ARGV[0]
password = nil
if ARGV[0].include?('@')
  password, address = ARGV[0].split '@'
  password = password[1..-1] # remove the leading colon ':'
end
host, port = address.split ':'
port = port.nil? ? 6379 : port.to_i
entries = ARGV[1] || 128
entries = entries.to_i
if password.nil?
  r = Redis.new host: host, port: port
else
  r = Redis.new(host: host,port: port, password: password,
        ssl: true, ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
end
data = r.slowlog :get, entries

data.each do |raw_entry|
  entry = Entry.new(raw_entry)
  puts "#{entry.time}: #{entry.milliseconds}ms, #{entry.full_command}"
end
