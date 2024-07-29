##
# MonitoringScriptMultithresholdRate
# Builds on MonitoringScriptMultithreshold but extends it to track named metrics in
# order to calculate rates
#
require 'digest/md5'
require 'etc'
require 'yaml'

# add self to load path
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'monitoring_script_multithreshold'

class FirstRunException < Exception; end
class InvalidYamlException < Exception; end
class InvalidTimestampException < Exception; end

class MonitoringScriptMultithresholdRate < MonitoringScriptMultithreshold
  RATE_METRICS = %w( )

  ALLOW_NEGATIVE_RATES = true

  COMMON_OPTIONS = {
    :help       => { :text => "Show this message" },
    :thresholds => { :text => "Thresholds (metric1=w1:c1,metric2=w2:c2)", :short => "t", :type => :string, :default => nil },
  }

  def evaluate_thresholds
    calc_rates && super
  end

  def calc_rates
    # unique signature per options combo
    options_hash_val = Digest::MD5.hexdigest(options.collect{|k,v| k != :thresholds ? "#{k}#{v}" : ""}.join("_"))[0..8]
    this_fname = File.basename($0).gsub(/[^a-zA-Z0-9\-_]/,"_")
    prev_metrics_filename = "/var/tmp/#{this_fname}.#{Etc.getlogin}.#{options_hash_val}"

    # initialize current metrics hash
    curr_metrics = {
      "ts" => Time.now.to_i
    }
    self.class::RATE_METRICS.each do |rate_metric|
      curr_metrics[rate_metric] = @metrics[rate_metric]
    end

    begin
      # fetch metrics last state file
      unless File.exist? prev_metrics_filename
        set_message("First run detected.")
        raise FirstRunException
      end

      begin
        prev_metrics = YAML.load_file(prev_metrics_filename)
      rescue ArgumentError
        set_message("Invalid YAML in #{prev_metrics_filename}")
        raise InvalidYamlException
      end

      prev_metrics_ts = prev_metrics["ts"].to_i
      prev_metrics_age = nil
      if prev_metrics_ts || prev_metrics_ts >= Time.now.to_i
        prev_metrics_age = Time.now.to_i - prev_metrics_ts
      else
        set_message("Invalid timestamp (ts key) in #{prev_metrics_filename}")
        raise InvalidTimestampException
      end

      if prev_metrics && prev_metrics_age && prev_metrics_age > 0
        set_metric("time_since", prev_metrics_age)
        self.class::RATE_METRICS.each do |name|
          if curr_metrics[name] && prev_metrics[name]
            delta = curr_metrics[name] - prev_metrics[name]
            if (delta >= 0 || self.class::ALLOW_NEGATIVE_RATES)
              set_metric("#{name}_sec", delta / prev_metrics_age.to_f)
            end
          end
        end
      end
    rescue FirstRunException, InvalidYamlException, InvalidTimestampException
      # absorb exceptions
    ensure
      write_curr_metrics(prev_metrics_filename, curr_metrics)
    end
    true
  end

  def write_curr_metrics(fname, metrics)
    File.open(fname, "w") do |fh|
      fh.write(metrics.to_yaml)
    end
  end
end
