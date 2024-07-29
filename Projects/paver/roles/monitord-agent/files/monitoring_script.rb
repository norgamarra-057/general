##
# MonitoringScript
# Class to provide a foundation for writing Nagios service checks (plugins) in
# Ruby.
#
# Override the service_check method with your implementation of this class.
#

# add self to load path
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require 'trollop'
require 'syslog'

class MonitoringScript
  class InvalidServiceName < Exception; end
  class InvalidMetricName  < Exception; end
  class InvalidStatusValue < Exception; end
  class MissingOptionError < Exception; end
  class InvalidMetricTransform < Exception; end

  DEFAULT_TO_ZERO_METRICS = []

  SERVICE_NAME = "override_me"
  SERVICE_DESC = "a monitoring script written in Ruby."
  PRIMARY_METRIC = nil
  VALID_NAME_REGEX = "[a-z0-9_\\-\\.]+"

  COMMON_OPTIONS = {
    :help     => { :text => "Show this message" },
    :critical => { :text => "Critical threshold", :short => "c", :type => :float, :default => nil },
    :warning  => { :text => "Warning threshold",  :short => "w", :type => :float, :default => nil },
  }

  # allowed statuses and their numeric value
  STATUSES = {
    0 => "OK",
    1 => "WARNING",
    2 => "CRITICAL",
    3 => "UNKNOWN",
  }
  # set consts for each status
  STATUSES.each do |val, name|
    const_set("STATUS_#{name}", val)
  end

  attr_reader :options
  attr_reader :metrics

  def initialize
    check_service_name
    check_primary_metric
    @metrics = {}
    @status = MonitoringScript::STATUS_UNKNOWN
    @message = nil

    # parse command line options
    service_name = self.class::SERVICE_NAME
    service_desc = self.class::SERVICE_DESC
    option_hash  = self.class::COMMON_OPTIONS
    if self.class.const_defined?("OPTIONS")
      option_hash.merge!(self.class::OPTIONS)
    end
    @options = Trollop::options do
      banner "#{service_name} - #{service_desc}"
      option_hash.each do |name, data|
        opt name, data.delete(:text), data
      end
    end

    # set default values to zero if overridden by subclass
    self.class::DEFAULT_TO_ZERO_METRICS.each do |metric|
      set_metric(metric, 0) if @metrics[metric].nil?
    end

    # trap signals
    Signal.trap("SIGHUP",  proc { exit_on_signal("HUP") })
    Signal.trap("SIGINT",  proc { exit_on_signal("INT") })
    Signal.trap("SIGTERM", proc { exit_on_signal("TERM") })
  end

  def check_service_name
    unless valid_name?(self.class::SERVICE_NAME)
      raise InvalidServiceName, "SERVICE_NAME must be only the characters #{VALID_NAME_REGEX}"
    end
  end

  def check_primary_metric
    unless valid_name?(self.class::PRIMARY_METRIC)
      raise InvalidMetricName, "PRIMARY_METRIC must be only the characters #{VALID_NAME_REGEX}"
    end
  end

  # actually do the service check
  def run!
    begin
      service_check
    rescue Exception => e
      set_message("Got exception: #{e} in #{e.backtrace[0]}")
      set_status(STATUS_UNKNOWN)
    end
    exit_normally
  end

  # ensure name (used for service and metric names) is defined and made only of
  # certain chars
  def valid_name?(name)
    unless name && name.match(/^#{VALID_NAME_REGEX}$/)
      return false
    end
    true
  end

  def valid_precision?(precision)
    return precision.is_a? Fixnum
  end

  # set a metric into the metrics hash, by default it's rounded to millis
  # you can use negative precision to round up,
  #   e.g. value=54786, round=true, precision = -3
  #   yields value=54000
  def set_metric(name, value, round = true, precision = 3)
    raise InvalidMetricName, "Metric '#{name}' must only use the characters #{VALID_NAME_REGEX}" unless valid_name?(name)
    raise InvalidMetricTransform, 'Precision must be +/- integer value only' unless valid_precision?(precision)
    if round
      @metrics[name] = ((value.to_f * 10 ** precision).round).to_f / 10 ** precision
    else
      @metrics[name] = value
    end
  end

  # set arbitrary text to go along with the output
  # disallow special pipe ("|") char
  def set_message(message)
    @message = message.tr('|', '-')
  end

  # validate and set status value
  def set_status(status)
    status = status.to_i
    raise InvalidStatusValue unless STATUSES[status]
    @status = status
  end

  # method that actually performs the check and sets status/metrics/etc.
  def service_check
    raise "Override service_check in your class"
  end

  def get_higher_is_better(warn, crit, args = {})
    higher_is_better = nil
    critical = crit
    warning = warn

    # figure out if we are after low or high numbers
    higher_is_better = nil
    if critical && warning
      if critical < warning
        higher_is_better = true
      else
        higher_is_better = false
      end
    elsif !args[:higher_is_better].nil?
      higher_is_better = args[:higher_is_better]
    elsif !args[:lower_is_better].nil?
      higher_is_better = !args[:lower_is_better]
    end

    if !args[:higher_is_better].nil?
      higher_is_better = args[:higher_is_better]
    elsif !args[:lower_is_better].nil?
      higher_is_better = !args[:lower_is_better]
    end

    if (higher_is_better.nil? && crit.all?{|n| warn.include? n})
      raise "Need thresholds or --critical and/or --warning."
    end
    return higher_is_better
  end

  def multi_scalar?(val)
    if(!val || val.nil? || val.class == Float)
      return false
    end
    mags_keys = MAGS.collect {|m| m[0]}.join("")
    if(val.match(/^([-]?[0-9]*\.?[0-9]+[#{mags_keys}]?)(\/[-]?[0-9]*\.?[0-9]+[#{mags_keys}]?)+/))
      arr = val.split('/')
      arr = arr.collect { |v| mag_to_b(v) }
      val = arr.join('/')
      if(!val.nil? && val.match(/^([-]?[0-9]*\.?[0-9]+)(\/[-]?[0-9]*\.?[0-9]+)+/))
        return true
      end
    end
    return false
  end

  def range?(val)
    if(!val || val.nil? || val.class == Float)
      return false
    end
    mags_keys = MAGS.collect {|m| m[0]}.join("")
    val_scan = val.scan(/^([-]?[0-9]*\.?[0-9]+[#{mags_keys}]?)-([-]?[0-9]*\.?[0-9]+[#{mags_keys}]?)$/)
    if(val_scan.nil? || val_scan.length != 1 || val_scan[0].length != 2)
      return false
    end
    min,max = val_scan[0]
    if(mag_to_b(min) > mag_to_b(max))
      raise "Threshold malformed, only ascending ranges are accepted: #{val}"
    end
    val = "#{mag_to_b(min)}-#{mag_to_b(max)}"
    if(val.match(/^[-]?[0-9]*\.?[0-9]+-[-]?[0-9]*\.?[0-9]+$/))
      return true
    end
    return false
  end

  def evaluate_metric_exactly(val, thresholds, args = {})
    if(val == thresholds[:critical])
      return STATUS_OK
    end
    return STATUS_CRITICAL
  end

  def evaluate_metric_multi_scalar(val, thresholds, args = {})
    raise "Value is nil" unless val
    if(val.class != Float)
      val = val.to_f
    end
    if(!thresholds.has_key?(:critical))
      return STATUS_UNKNOWN
    else
      crit = thresholds[:critical].split(/\//)
    end
    if(thresholds.has_key?(:warning))
      warn = thresholds[:warning].split(/\//)
    end
    crit.each do |c|
      if(mag_to_b(c) == val)
        return STATUS_OK
      end
    end
    if(thresholds.has_key?(:warning))
      warn.each do |w|
        if(mag_to_b(w) == val)
          return STATUS_WARNING
        end
      end
    end
    return STATUS_CRITICAL
  end

  def evaluate_metric_high_low_range(val, thresholds, args = {})
    warn = thresholds[:warning]
    crit = thresholds[:critical]
    higher_is_better = get_higher_is_better(warn, crit)
    if higher_is_better
      if(val <= crit)
        return STATUS_CRITICAL
      elsif(val <= warn)
        return STATUS_WARNING
      end
    else
      if(val >= crit)
        return STATUS_CRITICAL
      elsif(val >= warn)
        return STATUS_WARNING
      end
    end
    return STATUS_OK
  end

  def evaluate_metric_consec_range(val, thresholds, args = {})
    if(thresholds.has_key?(:warning))
      w_min = thresholds[:warning]
      w_max = false
    elsif(thresholds.has_key?(:warning_min) && thresholds.has_key?(:warning_max))
      w_min = thresholds[:warning_min]
      w_max = thresholds[:warning_max]
    end
    c_min = thresholds[:critical_min]
    c_max = thresholds[:critical_max]
    if(!c_min || !c_max)
      return STATUS_UNKNOWN
    end
    if(!w_min && w_max)
      return STATUS_UNKNOWN
    end
    if(val < c_min || val > c_max)
      return STATUS_CRITICAL
    end
    if(w_min && !w_max)
      if(val != w_min)
        return STATUS_WARNING
      end
    elsif(w_min && w_max)
      if(val < w_min || val > w_max)
        return STATUS_WARNING
      end
    end
    return STATUS_OK
  end

  def are_ranges_valid?(thresholds)
    if((thresholds.has_key?(:warning) && thresholds.has_key?(:warning_min)) || !thresholds.has_key?(:critical_min) || !thresholds.has_key?(:critical_max))
      return false
    end

    c_min = thresholds[:critical_min]
    c_max = thresholds[:critical_max]
    if(thresholds.has_key?(:warning))
      w_min = thresholds[:warning]
      w_max = false
    elsif(thresholds.has_key?(:warning_min) && thresholds.has_key?(:warning_max))
      w_min = thresholds[:warning_min]
      w_max = thresholds[:warning_max]
    else
      if(range?("#{c_min}-#{c_max}"))
        return true
      end
      return false
    end

    if(!range?("#{c_min}-#{c_max}"))
      return false
    end
    if((w_min && w_max) && (w_min < c_min || w_max > c_max))
      return false
    end
    if(!w_max && (w_min < c_min || w_min > c_max))
      return false
    end
    return true
  end

  def scalar?(val)
    mags_keys = MAGS.collect {|m| m[0]}.join("")
    if(val.nil? || !val)
      return false
    end
    if(val.class == Float)
      val = val.to_s
    end
    if(!val.match(/^([-]?[0-9]*\.?[0-9]+[#{mags_keys}]?)$/))
      return false
    end
    val = mag_to_b(val).to_s
    if(val.match(/^[-]?[0-9]*\.?[0-9]+$/))
      return true
    end
    return false
  end

  def parse_thresholds(thresh_pair, args = {})
    thresholds = {}
    mags_keys = MAGS.collect {|m| m[0]}.join("")
    key,vals = thresh_pair.split("=")
    if(vals.match(/:/))
      warn,crit = vals.split(":")
      if(range?(crit))
        crit_scan = crit.scan(/^([-]?[0-9]*\.?[0-9]+[#{mags_keys}]?)-([-]?[0-9]*\.?[0-9]+[#{mags_keys}]?)$/)
        if(crit_scan.nil? || crit_scan.length != 1 || crit_scan[0].length != 2)
          raise "Critical threshold malformed: #{crit}"
        end
        c_min,c_max=crit_scan[0]
        if(range?(warn))
          warn_scan = warn.scan(/^([-]?[0-9]*\.?[0-9]+[#{mags_keys}]?)-([-]?[0-9]*\.?[0-9]+[#{mags_keys}]?)$/)
          if(warn_scan.nil? || warn_scan.length != 1 || warn_scan[0].length != 2)
            raise "Warning threshold malformed: #{warn}"
          end
          w_min,w_max=warn_scan[0]
          thresholds[key] = { :warning_min => mag_to_b(w_min), :warning_max => mag_to_b(w_max), :critical_min => mag_to_b(c_min), :critical_max => mag_to_b(c_max) }
        elsif(scalar?(warn))
          thresholds[key] = { :warning=> mag_to_b(warn), :critical_min => mag_to_b(c_min), :critical_max => mag_to_b(c_max) }
        else
          raise "Threshold malformed, if critical is a range, then warning must be either scalar or range, #{warn} #{crit}"
        end
      elsif( (multi_scalar?(warn) && multi_scalar?(crit)) || (multi_scalar?(warn) && scalar?(crit)) || (scalar?(warn) && multi_scalar?(crit)) )
        if(range?(warn) || range?(crit))
          raise "Threshold malformed, multi-scalar and range: #{warn}, #{crit}"
        end
        thresholds[key] = { :warning => warn, :critical => crit }
      elsif(scalar?(warn) && scalar?(crit))
        thresholds[key] = { :warning => mag_to_b(warn), :critical => mag_to_b(crit) }
      elsif(range?(warn) && !range?(crit))
        raise "Thresholds malformed, warn cannot be a range if crit is not also a range because crit must contain warn, #{warn}, #{crit}"
      else
        raise "Thresholds malformed, mismatch: #{warn}, #{crit}"
      end
    else
      if(vals)
        if(range?(vals))
          val_scan = vals.scan(/^([-]?[0-9]*\.?[0-9]+[#{mags_keys}]?)-([-]?[0-9]*\.?[0-9]+[#{mags_keys}]?)$/)
          if(val_scan.nil? || val_scan.length != 1 || val_scan[0].length != 2)
            raise "Threshold malformed: #{vals}"
          end
          c_min,c_max=val_scan[0]
          thresholds[key] = { :critical_min => mag_to_b(c_min), :critical_max => mag_to_b(c_max) }
        elsif(multi_scalar?(vals))
          thresholds[key] = { :critical => vals }
        else
          thresholds[key] = { :critical => mag_to_b(vals) }
        end
      end
    end
    return thresholds
  end

  def thresholds_type(thresholds)
    # check for exactly, single scalar only, no / : or -
    if(!thresholds.has_key?(:warning) && thresholds.has_key?(:critical))
      if(scalar?(thresholds[:critical]))
        return :exactly
      elsif(multi_scalar?(thresholds[:critical]))
        return :multi_scalar
      elsif(range?(thresholds[:critical]))
        return :consec_range
      end
    end

    # check for multi scalar, can mix scalar and multi scalar
    if( ( (!thresholds[:warning] || scalar?(thresholds[:warning]) ) && multi_scalar?(thresholds[:critical]) ) || (multi_scalar?(thresholds[:warning]) && (multi_scalar?(thresholds[:critical]) || scalar?(thresholds[:critical])) ) )
      return :multi_scalar
    end

    #check for range (warning can be scalar or range as long as embedded in critical which must be range)
    if(are_ranges_valid?(thresholds))
      return :consec_range
    end

    #check for hi low, each must be single scalar
    if(scalar?(thresholds[:warning]) && scalar?(thresholds[:critical]))
      return :high_low_range
    end

    raise "Thresholds malformed: #{thresholds.inspect}"
  end

  def evaluate_metric(val, thresholds, args = {})
    case thresholds_type(thresholds)
      when :exactly
        return evaluate_metric_exactly(val, thresholds, args = {})
      when :multi_scalar
        return evaluate_metric_multi_scalar(val, thresholds, args = {})
      when :consec_range
        return evaluate_metric_consec_range(val, thresholds, args = {})
      when :high_low_range
        return evaluate_metric_high_low_range(val, thresholds, args = {})
      else
        raise "Thresholds malformed: #{thresholds.inspect}"
    end
  end

  # normal method of comparing primary metric with thresholds
  def evaluate_primary(args = {})
    primary_metric = @metrics[self.class::PRIMARY_METRIC]
    unless primary_metric
      raise "Primary metric not set."
    end
    unless options[:critical] || options[:warning]
      raise "No warning or critical threshold set."
    end

    set_metric("critical", options[:critical]) if options[:critical]
    set_metric("warning",  options[:warning])  if options[:warning]

    thresholds = { :warning => options[:warning], :critical => options[:critical] }

    status = nil
    begin
      status = evaluate_metric(primary_metric, thresholds, args)
    rescue Exception => e
      raise "Error evaluating #{self.class::PRIMARY_METRIC} (#{e})"
    end

    set_status(status)
  end

  # return a nagios-like string
  def to_s
    [
      self.class::SERVICE_NAME,
      "#{STATUSES[@status]}:",
      (@metrics[self.class::PRIMARY_METRIC] ? "#{self.class::PRIMARY_METRIC}=#{@metrics[self.class::PRIMARY_METRIC]}" : nil),
      @message ? "(#{@message})" : nil,
      "|",
      @metrics.keys.sort.collect{|name| "#{name}=#{@metrics[name]}"}.join(";"),
    ].compact.join(" ")
  end

  # conversion of values like 10M <=> 10485760
  MAGS = [
    ["T",1024.0**4],
    ["G",1024.0**3],
    ["M",1024.0**2],
    ["K",1024.0],
  ]

  def mag_to_b(str)
    number_part = str.to_f
    letter_part = str.to_s.gsub(%r{[0-9.-]}, "").upcase
    MAGS.each do |mag,mult|
      if mag == letter_part
        return number_part * mult
      end
    end
    return number_part
  end

  def b_to_mag(kb)
    MAGS.each do |mag,mult|
      si = kb / mult
      if si >= 1
        return "%0.2f%s" % [si, mag]
      end
    end
    return "%0.2fK" % [kb]
  end

  private
  # log something to syslog
  def log(msg)
    Syslog.open("nagios_plugin #{File.basename($0)}", Syslog::LOG_PID | Syslog::LOG_CONS) { |s| s.info msg }
  end

  # signal handler callback
  def exit_on_signal(sig)
    set_status(STATUS_UNKNOWN)
    set_message("Got signal: #{sig}")
    exit_normally
  end

  # run_command(cmd, arg1, arg2, ...) safely runs a command without using
  # a Unix command shell. This means any wildcards, quotes, redirections,
  # and so on in the command name or arguments are not interpreted by a
  # shell, and are passed directly to the command being run. Accepts a
  # block of code to run, and sets $? to the return status of the process.
  # Dies if the command cannot be executed.
  def run_command(cmd, *args)
    raise ArgumentError.new('missing required cmd to run') if cmd.nil?
    rd, wr = IO.pipe
    if fork
      wr.close
      if block_given?
        rd.each { |line| yield(line) }
      else
        rd.read
      end
      rd.close
      Process.wait
    else
      rd.close
      $stdout.reopen(wr)
      $stderr.reopen(wr)
      exec cmd, *args
      raise "exec #{cmd} failed"
    end
    $? == 0 # return a bool indicating a successful exit
  end

  # output string and exit with appropriate status code
  def exit_normally
    puts self.to_s
    exit(@status)
  end
end
