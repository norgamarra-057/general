##
# MonitoringScriptMultithreshold
# Builds on MonitoringScript but extends it to allow for multiple metric thresholds.
#

# add self to load path
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'monitoring_script'

class MonitoringScriptMultithreshold < MonitoringScript
  COMMON_OPTIONS = {
    :help       => { :text => "Show this message" },
    :thresholds => { :text => "Thresholds (metric1=w1:c1,metric2=w2:c2)", :short => "t", :type => :string, :default => nil },
  }

  # normal method of comparing primary metric with thresholds
  def evaluate_primary(args = {})
    raise "use of evaluate_primary() in MonitoringScriptMultithreshold does not make sense"
  end

  def check_primary_metric
    true # no primary metric in a multithreshold
  end

  def evaluate_thresholds
    thresholds = {}
    unless options[:thresholds]
      raise "Must pass a value with --thresholds, e.g. metric1=w1:c1,metric2=w2:c2"
    end

    options[:thresholds].split(",").each do |thresh_pair|
      thresholds = thresholds.merge(parse_thresholds(thresh_pair))
    end

    max_status = 0
    messages = []
    messages << @message if @message
    status = nil

    metric_snapshot = @metrics.clone
    thresholds.each do |thresh_name, thresh_data|
      found = false
      metric_snapshot.each { |metric_name,metric_value|
        # to check for wildcard matches using a regex, replace * with .*
        if(metric_name.match("^#{Regexp.escape(thresh_name).gsub('\*','.*')}$"))
          status = evaluate_single_threshold(metric_name, metric_snapshot[metric_name], thresh_data)
          messages << "#{metric_name}=#{metric_snapshot[metric_name]}:#{STATUSES[status]}"
          found = true
          if status > max_status
            max_status = status
          end
        end
      }
      if(!found)
        status = STATUS_UNKNOWN
        messages << "#{thresh_name}=UNKNOWN"
      end
      if status > max_status
        max_status = status
      end
    end

    if @status == MonitoringScript::STATUS_UNKNOWN || max_status >= @status
      # only let status get worse
      set_status(max_status)
      if max_status != MonitoringScript::STATUS_OK
        set_message(messages.join(" "))
      end
    end
  end

  def evaluate_single_threshold(thresh_name, thresh_val, thresh_data)
    # Match and split on / is to handle multi-scalar case since each threshold in output metrics must be a float
    if(thresh_data.has_key?(:warning))
      if(thresh_data[:warning].class == String && thresh_data[:warning].match('/'))
        w_count=0
        thresh_data[:warning].split('/').each { |w|
          if(w.class == Float)
            set_metric("#{thresh_name}_warning_#{w_count}", w)
          else
            set_metric("#{thresh_name}_warning_#{w_count}", mag_to_b(w))
          end
          w_count += 1
        }
      else
        set_metric("#{thresh_name}_warning",  thresh_data[:warning])
      end
    end
    if(thresh_data.has_key?(:warning_min))
      set_metric("#{thresh_name}_warning_min",  thresh_data[:warning_min])
    end
    if(thresh_data.has_key?(:warning_max))
      set_metric("#{thresh_name}_warning_max",  thresh_data[:warning_max])
    end
    if(thresh_data.has_key?(:critical))
      if(thresh_data[:critical].class == String && thresh_data[:critical].match('/'))
        c_count=0
        thresh_data[:critical].split('/').each { |c|
          if(c.class == Float)
            set_metric("#{thresh_name}_critical_#{c_count}", c)
          else
            set_metric("#{thresh_name}_critical_#{c_count}", mag_to_b(c))
          end
          c_count += 1
        }
      else
        set_metric("#{thresh_name}_critical",  thresh_data[:critical])
      end
    end
    if(thresh_data.has_key?(:critical_min))
      set_metric("#{thresh_name}_critical_min",  thresh_data[:critical_min])
    end
    if(thresh_data.has_key?(:critical_max))
      set_metric("#{thresh_name}_critical_max",  thresh_data[:critical_max])
    end
    begin
      status = evaluate_metric(thresh_val, thresh_data)
    rescue Exception => e
      raise "Error evaluating #{thresh_name} (#{e} #{e.backtrace[0].split(":").last})"
    end

    return status
  end
end
