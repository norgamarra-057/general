require 'json'
require 'uri'
require 'socket'
require 'net/http'

class ChecksRunner

  ACTIVE_FLAG_FILE = '/var/groupon/raas_mon/raas-mon.active'
  START_SECOND = 10
  CHECKS_DIR = "/usr/local/libexec/redislabs"

  def initialize(check_name, monitoring_cluster, results_uri, rlec_mons)
    @start_minute = Time.now.utc.min # retain the minute when we started, this job lasts till next minute
    @check_name = check_name
    @check_path = File.join(CHECKS_DIR, @check_name)
    @check_path_prefix = "#{@check_path} "
    @check_class = nil
    @schedule = {}
    @threads = []
    @monitord_user_agent = 'raas-mon'
    @monitoring_cluster = monitoring_cluster
    @results_uri = results_uri
    @rlec_mons = rlec_mons
  end

  def load_checks
    $logger.info "load_checks=#{@check_name}"
    load @check_path
    @check_class = ObjectSpace.each_object(Object).detect{|c| c.class==Class && c.to_s.start_with?('Check') && c.ancestors.include?(MonitoringScript)}
    raise "couldn't find any check class for @check_name" unless @check_class
    @rlec_mons.each do |k,v|
      if v.is_a?(Hash)
        load_check(k, v)
      else # Array
        v.each do |m|
          load_check(k, m)
        end
      end
    end
  end

  def run
    $logger.info "run=start"
    if @schedule.empty?
      $logger.warn "schedule_empty"
      return
    end
    # cron doesn't start jobs at second 0, but at second ~2
    # On the other hand we assume cron will run this job at a second < START_SECOND
    # In order to process every single second of the minute, let's start
    #  processing at START_SECOND and finish at START_SECOND+60
    sleep_till_start_second
    60.times do |t|
      @now = Time.now.utc
      break if (t > 0 and @now.sec == START_SECOND) # just in case the job started late
      to_dispatch = @schedule[@now.sec] || []
      $logger.info "to_dispatch=#{to_dispatch.size}"
      process_this_second(to_dispatch) unless to_dispatch.empty?
      while Time.now.utc.to_i == @now.to_i do sleep 0.2 end # 0.2 vs 1 to avoid missing the next second
    end
    $logger.info "threads_wait"
    @threads.each(&:join)
    $logger.info "run=end"
  end

  def sleep_till_start_second
    to_sleep = START_SECOND - Time.now.utc.sec - 1
    $logger.info "sleep_till_start_second to_sleep=#{to_sleep}"
    sleep to_sleep
    # just in case we woke up at START_SECOND - 1ms
    while Time.now.utc.sec != START_SECOND do sleep 0.2 end # 0.2 vs 1 to avoid missing the next second
  end

  def process_this_second(to_dispatch)
    to_dispatch.each do |check|
      @threads << Thread.new {
        begin
          $logger.info("event=run monitor=#{check[:monitor_name]} target=#{check[:spoof_host]} options=#{check[:instance].options}")
          check[:instance].run!
          nagios_str = check[:instance].to_s
          status = check[:instance].get_status
          $logger.info "event=send_result_to_monitord monitor=#{check[:monitor_name]} target=#{check[:spoof_host]} run_every=#{check[:run_every]} monitoring_cluster=#{@monitoring_cluster} status=#{status} nagios_str.size=#{nagios_str.size}"
          if File.exist?(ACTIVE_FLAG_FILE)
            send_result_to_monitord(check[:spoof_host], check[:monitor_name], check[:run_every], nagios_str, status)
          else
            $logger.warn "raas-mon.active=false"
          end
        rescue
          $logger.error $!
        end
      }
    end
  end

  def send_result_to_monitord(path_host, name, run_every, nagios_str, status)
    begin
      uri = @results_uri
      request = Net::HTTP::Post.new(uri.request_uri)
      request.form_data = {
        "run_every" => run_every,
        "path" => "#{@monitoring_cluster}/#{path_host}",
        "monitor" => name,
        "status" => status,
        "output" => nagios_str
      }
      request.add_field("User-Agent", @monitord_user_agent)
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = http.read_timeout = 10
      resp = http.start {|http| http.request(request)}
      unless resp.code=='200'
        $logger.error "event=monitord_server_error_code monitor=#{name} target=#{path_host} status_code=#{resp.code} body=\"#{resp.body}\""
      end
    rescue SocketError
      $logger.error "event=monitord_connection_failed monitor=#{name} target=#{path_host}"
    rescue Errno::ECONNREFUSED
      $logger.error "event=monitord_connection_refused monitor=#{name} target=#{path_host}"
    rescue Exception => e
      $logger.error "event=monitord_server_error monitor=#{name} target=#{path_host}"
      $logger.info "event=monitord_server_error monitor=#{name} target=#{path_host}, backtrace.first: #{e.backtrace.first}, message: #{e.message}, e.class: #{e.class}"
      $logger.info e.backtrace
    end
  end

  def load_check(monitor_name, attribs)
    shell_command = attribs['shell_command']
    return unless shell_command.start_with?(@check_path_prefix)
    second = get_exec_second(str_hash(shell_command), attribs['run_every'].to_i, @start_minute)
    return unless second
    options = get_options(shell_command)
    instance = create_instance(options)
    check = {
      monitor_name: monitor_name,
      instance: instance,
      spoof_host: attribs['spoof_host'].split(':').last, # ex: nil:test1.us.raas-test1.grpn
      run_every: attribs['run_every'],
    }
    @schedule[second] ||= []
    @schedule[second] << check
  end

  def create_instance(options)
    # monkey-patch fun:
    $current_check_options = options
    def Trollop::options # overwrite Trollop, used by monitoring_script.rb
      $current_check_options
    end
    instance = @check_class.new
    def instance.exit_normally
      # avoid output to STDOUT and calling exit()
    end
    def instance.exit_on_signal(sig)
      # since we're overwriting exit_normally, we need to exit on Signal.trap
      exit 0
    end
    def instance.get_status # get a way to get status
      @status
    end
    instance
  end

  def get_exec_second(hash, run_every, start_minute)
    if run_every == 60
      hash % run_every
    else
      rel_start_minute = start_minute % (run_every / 60)
      second_in_run_every_cycle = hash % run_every
      minute_in_run_every_cycle = second_in_run_every_cycle / 60
      return nil if minute_in_run_every_cycle != rel_start_minute
      second_in_run_every_cycle % 60
    end
  end

  def get_options(shell_command)
    # shell_command = "/usr/local/libexec/redislabs/check_cluster_alerts --clustername=#{cluster_name} --thresholds=cluster_even_node_count=0.1:2,cluster_ram_overcommit=0.1:2,cluster_*=0"
    shell_command_args = {}
    shell_command.split.each do |arg|
      next unless arg.start_with?('--')
      k = arg[2..(arg.index('=')-1)]
      v = arg[(arg.index('=')+1)..-1]
      shell_command_args[k.to_sym] = v
    end
    shell_command_args
  end

  def str_hash(str)
    str.bytes.inject{|sum,x| sum + x }
  end

end

