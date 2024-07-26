require 'json'
require 'uri'
require 'net/https'

class Wavefront

  include Utils

  FAM = {
    cpu: 'cpu',
    eviction_policy: 'eviction_policy',
    nic: 'nic',
    node_type: 'node_type',
    oom: 'oom',
    stale: 'stale',
    telegraf: 'telegraf',
    resque: 'resque',
  }

  def initialize(aws_region:, env:, engine:, group:)
    @wf_max_items = 1000 # RAAS-343
    @wf_url = "https://groupon.wavefront.com/api/v2"
    @wf_api_token = ENV['WF_API_TOKEN']
    @aws_region = aws_region
    @env = env
    @engine = engine
    @group = group
    @targets = {}
    @targets['warn'] = 'target:Ou1QMWOcswyed81r' # raas-alerts@groupon.com
    @targets['severe'] = 'target:3B7eg5DJYHYeFDwJ' if @env == 'prod' # raas-pager@groupon.com
    @target_all_triggers = 'target:KBO9pA8YUDQF3iOF' # raas-alerts@groupon.com including NO_DATA
  end

  def http_headers
    {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json',
      'Authorization' => "Bearer #{@wf_api_token}",
    }
  end

  def get_tag_query(tag)
    {
      "key" => "tags",
      "value" => tag,
      "matchingMethod" => "EXACT"
    }
  end

  def alerts_get_query(family)
    q = {
      "limit" => 1000,
      "offset" => 0,
      "query" => [
        get_tag_query('raas'),
        get_tag_query('aws'),
        get_tag_query('autocreated'),
        get_tag_query(family),
        get_tag_query(@env),
        get_tag_query(@aws_region),
      ],
      "sort" => {
        "ascending" => true,
        "field" => "string",
        "default" => true
      }
    }
    q['query'] << get_tag_query(@group) unless [FAM[:telegraf], FAM[:resque]].include?(family)
    q
  end

  def post_search_alerts(family)
    uri = URI(@wf_url+"/search/alert")
    $logger.info("post_search_alerts=#{uri} family=#{family}")
    req = Net::HTTP::Post.new(uri, http_headers)
    req.body = alerts_get_query(family).to_json
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      res = http.request(req)
      raise "post_search_alerts=#{res.code}" unless res.code.start_with?('20')
      return JSON.parse(res.body)
    end
  end

  def fetch_alerts(family)
    res = post_search_alerts(family)
    raise "revisit RAAS-343" if res['response']['moreItems'] || res['response']['items'].size >= @wf_max_items
    res['response']['items'].map do |i|
      # we only care about these attributes:
      i.slice(
        'id',
        'name',
        'target',
        'targets',
        'alertType',
        'condition',
        'conditions',
        'severity',
        'additionalInformation',
        'tags',
        'displayExpression',
        'minutes',
        'resolveAfterMinutes',
        'notificationResendFrequencyMinutes',
        'processRateMinutes')
    end.select{|a| (a['tags']['customerTags'] & [@engine, 'telegraf', 'resque']).any?}
  end

  def put_alert(alert)
    uri = URI("#{@wf_url}/alert/#{alert['id']}")
    $logger.info("put_alert=#{alert['name']} id=#{alert['id']}")
    req = Net::HTTP::Put.new(uri, http_headers)
    req.body = alert.to_json
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      res = http.request(req)
      raise "put_alert=#{res.code}" unless res.code.start_with?('20')
    end
  end

  def update_alerts(alerts)
    alerts.each do |alert|
      put_alert(alert)
    end
  end

  def delete_alert(alert)
    uri = URI("#{@wf_url}/alert/#{alert['id']}")
    $logger.info("delete_alert=#{alert['name']} id=#{alert['id']}")
    req = Net::HTTP::Delete.new(uri, http_headers)
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      res = http.request(req)
      raise "delete_alert=#{res.code}" unless res.code.start_with?('20')
    end
  end

  def delete_alerts(alerts)
    alerts.each do |alert|
      delete_alert(alert)
    end
  end

  def post_alert(alert)
    uri = URI("#{@wf_url}/alert")
    $logger.info("post_alert=#{alert['name']}")
    req = Net::HTTP::Post.new(uri, http_headers)
    req.body = alert.to_json
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      res = http.request(req)
      raise "post_alert=#{res.code}" unless res.code.start_with?('20')
    end
  end

  def create_alerts(alerts)
    alerts.each do |alert|
      post_alert(alert)
    end
  end

  def base_alert_hash(special_tags)
    tags = {
      'customerTags' => [
        "aws",
        "raas",
        "autocreated",
        @env,
        @aws_region,
      ]
    }
    tags['customerTags'] += special_tags

    {
      'alertType' => "CLASSIC",
      'displayExpression' => "",
      'notificationResendFrequencyMinutes' => 60,
      'processRateMinutes' => 1,
      'tags' => tags
    }
  end

  def alerts(tfdata)
    case @engine
    when 'memcached'
      common_alerts(tfdata) + memcached_alerts(tfdata)
    when 'redis'
      common_alerts(tfdata) + redis_alerts(tfdata)
    end
  end

  def common_alerts(tfdata)
    instance = tfdata[:cluster_name]
    instance_class = tfdata[:tpl_name]
    service = tfdata[:service]
    ticket = tfdata[:ticket]
    num_nodes = tfdata[:num_nodes]
    num_nodes *= 2 if @engine == 'redis' && @env != 'staging' # replication
    res = []

    probe_metric = @engine == 'memcached' ? 'memcached.bytes' : 'redis.maxmemory'
    res << {
      'name' => "raas stale node: #{instance} #{@aws_region}",
      'family' => FAM[:stale],
      'minutes' => 5,
      'target' => @env == 'prod' ? "raas-alerts@groupon.com" : "raas-alerts@groupon.com",
      'condition' => "count(count(ts(\"#{probe_metric}\", server=\"#{wf_servers_wildcard(tfdata)}\"), server)) != #{num_nodes}",
      'severity' => 'SEVERE',
      'additionalInformation' => "number of nodes reporting metrics != #{num_nodes} \nservice: #{service}\nticket: #{ticket}",
    } unless tfdata[:autoscaling]

    max_mem_metric = @engine == 'memcached' ? 'memcached.limit.maxbytes' : 'redis.maxmemory'
    res << {
      'name' => "Inconsistent node type: #{instance} #{@aws_region}",
      'family' => FAM[:node_type],
      'minutes' => 5,
      'target' => @env == 'prod' ? "raas-alerts@groupon.com" : "raas-alerts@groupon.com",
      'condition' => "abs(ts(\"#{max_mem_metric}\", server=\"#{wf_servers_wildcard(tfdata)}\") - #{allocable_mem(tfdata[:node_type])}) > 50000000", # diff > 50MB
      'severity' => 'WARN',
      'additionalInformation' => "Memory doesn't match the specified node type on Terraform\nservice: #{service}\nticket: #{ticket}\nrunbook: https://confluence.groupondev.com/display/RED/RaaS+Cloud+Manual#RaaSCloudManual-Inconsistentnodetype",
    }

    res.map{|a| base_alert_hash(special_tags=[@engine, instance_class, a['family'], @group]).merge(a)}
  end

  def memcached_alerts(tfdata)
    []
  end

  def redis_alerts(tfdata)
    instance = tfdata[:cluster_name]
    instance_class = tfdata[:tpl_name]
    service = tfdata[:service]
    ticket = tfdata[:ticket]
    res = []

    expr_used_mem = "ts(\"redis.used.memory\", server=\"#{wf_servers_wildcard(tfdata)}\" and replication_role=\"master\")"
    expr_max_mem = "ts(\"redis.maxmemory\", server=\"#{wf_servers_wildcard(tfdata)}\" and replication_role=\"master\")"
    expr_used_ssd = "ts(\"aws.elasticache.bytesusedforcache\", source=\"#{instance}-*\" and Region=\"#{@aws_region}\" and Tier=\"SSD\")"
    expression =  "#{expr_used_mem} / #{expr_max_mem}"
    expression =  "(#{expr_used_mem} + #{expr_used_ssd}) / (#{expr_max_mem}*(1+1/0.75/.265))" if tfdata[:data_tiering]
    if tfdata[:oom_thresholds]
      oom_warn, oom_severe = tfdata[:oom_thresholds].split(':').map{|t| (t.to_f/100).to_s}
    else
      oom_warn, oom_severe = '0.8', '0.9'
      if @env == 'staging'
        oom_warn, oom_severe = '0.95', '0.99'
      end
    end
    res << {
      'name' => "OOM: #{instance} #{@aws_region}",
      'family' => FAM[:oom],
      'alertType' => 'THRESHOLD',
      'targets' => @targets,
      'displayExpression' => expression,
      'conditions' => {
        'warn' => "#{expression} > #{oom_warn}",
        'severe' => "#{expression} > #{oom_severe}"
      },
      'minutes' => 5,
      'additionalInformation' => "Redis is running out of memory\nservice: #{service}\nticket: #{ticket}\nrunbook: https://confluence.groupondev.com/display/RED/RaaS+Cloud+Manual#RaaSCloudManual-RedisOOM",
    } unless tfdata[:OOMAlertsOptOut]

    # Adding 100 prevents alerting when there is only one foo testing key without expiration
    # Adding 100 becomes negligible when a cache has +1000 keys
    res << {
      'name' => "EvictionPolicy: #{instance} #{@aws_region}",
      'family' => FAM[:eviction_policy],
      'minutes' => 5,
      'target' => @env == 'prod' ? "raas-alerts@groupon.com" : "raas-alerts@groupon.com",
      'condition' => "( 100 + ts(\"redis.keyspace.expires\", server=\"#{wf_servers_wildcard(tfdata)}\" and replication_role=\"master\" and maxmemory_policy=\"volatile-lru\")) / ts(\"redis.keyspace.keys\", server=\"#{wf_servers_wildcard(tfdata)}\" and replication_role=\"master\" and maxmemory_policy=\"volatile-lru\") < 0.5",
      'severity' => 'SEVERE',
      'additionalInformation' => "Redis relying on volatile-lru evictions, but not setting expiration on their keys\nservice: #{service}\nticket: #{ticket}\nrunbook: https://confluence.groupondev.com/display/RED/RaaS+Cloud+Manual#RaaSCloudManual-Redisinconsistentevictionpolicy",
    } if tfdata[:OOMAlertsOptOut]

    res << {
      'name' => "CPU: #{instance} #{@aws_region}",
      'family' => FAM[:cpu],
      'minutes' => 5,
      'target' => @env == 'prod' ? "raas-pager@groupon.com" : "raas-alerts@groupon.com",
      'condition' => "rate(ts(\"redis.used.cpu.sys\", server=\"#{wf_servers_wildcard(tfdata)}\"))+rate(ts(\"redis.used.cpu.user\", server=\"#{wf_servers_wildcard(tfdata)}\")) > 2.8",
      #"ts(\"aws.elasticache.enginecpuutilization\", source=\"#{service}-*\" and Region=\"#{@aws_region}\" and CacheNodeId=\"*\") > 0.9",
      'severity' => 'SEVERE',
      'additionalInformation' => "High Redis CPU usage\nservice: #{service}\nticket: #{ticket}\nrunbook: https://confluence.groupondev.com/display/RED/RaaS+Cloud+Manual#RaaSCloudManual-RedisHighCPUUsage",
    }

    res << {
      'name' => "NIC: #{instance} #{@aws_region}",
      'family' => FAM[:nic],
      'minutes' => 5,
      'target' => @env == 'prod' ? "raas-alerts@groupon.com" : "raas-alerts@groupon.com",
      'condition' => "rate(ts(\"redis.total.net.output.bytes\", server=\"#{wf_servers_wildcard(tfdata)}\"))*8 > #{nic(tfdata)}",
      'severity' => 'WARN',
      'additionalInformation' => "High Redis NIC usage\nservice: #{service}\nticket: #{ticket}\nrunbook: https://confluence.groupondev.com/display/RED/RaaS+Cloud+Manual#RaaSCloudManual-RedisHighNICUsage",
    }

    res.map{|a| base_alert_hash(special_tags=[@engine, instance_class, a['family'], @group]).merge(a)}
  end

  def region_env_alerts
    res = []

    res << {
      'name' => "resque-web pod still running in #{@env} #{@aws_region}",
      'family' => FAM[:resque],
      'resolveAfterMinutes' => 10,
      'minutes' => 60*24,
      'target' => @env == 'prod' ? "raas-alerts@groupon.com" : "raas-alerts@groupon.com",
      'condition' => "count(ts(prometheus.kubestate_.deployment__replicas__available, namespace=\"raas-*\" and deployment=resque and env=\"#{@env=='prod' ? 'production' : 'stable'}\" and region=\"#{@aws_region}\")) > 0",
      'severity' => 'WARN',
      'additionalInformation' => "run: kubectl delete deployment resque",
    }

    res << {
      'name' => "num of telegraf-raas pods in #{@env} #{@aws_region}",
      'family' => FAM[:telegraf],
      'minutes' => 5,
      'target' => @target_all_triggers,
      'condition' => "count(ts(\"procstat.memory.usage.max\", source=\"telegraf-raas-*\" and env=\"#{@env=='prod' ? 'production' : @env}\" and region=\"#{@aws_region}\")) != 1",
      'severity' => 'WARN',
      'additionalInformation' => "number of telegraf-raas pods != 1\nCheck using kubectl",
    }

    res << {
      'name' => "telegraf-raas gather errors in #{@env} #{@aws_region}",
      'family' => FAM[:telegraf],
      'minutes' => 5,
      'target' => @target_all_triggers,
      'condition' => "ratediff(min(ts(\"internal.agent.gather.errors\", source=\"telegraf-raas-*\" and env=\"#{@env=='prod' ? 'production' : @env}\" and region=\"#{@aws_region}\")))",
      'severity' => 'WARN',
      'additionalInformation' => "Check telegraf-raas pod logs using kubectl",
    }

    res << {
      'name' => "telegraf-raas restarted in #{@env} #{@aws_region}",
      'family' => FAM[:telegraf],
      'minutes' => 1,
      'target' => @target_all_triggers,
      'condition' => "ts(\"prometheus.kubestate_.pod__restarts__5m\", cluster=\"conveyor-*\" and pod=\"telegraf-raas-*\" and container=\"telegraf-raas\" and namespace=\"raas-mon-#{@env=='prod' ? 'production' : @env}\" and region=\"#{@aws_region}\") > 0",
      'severity' => 'WARN',
      'additionalInformation' => "Check telegraf-raas dead pod logs using kubectl logs -f <pod_id> --previous",
    }

    res.map{|a| base_alert_hash(special_tags=[a['family']]).merge(a)}
  end

  def similar?(alert1, alert2)
    x = alert1.clone
    y = alert2.clone
    [x, y].each do |a|
      a.delete('id')
      a.delete('family')
      a['tags'] = a['tags']['customerTags'].sort
      a.delete('condition') if a['alertType'] == 'THRESHOLD' # use conditions (plural)
      a.delete('severity') if a['alertType'] == 'THRESHOLD' # we don't define severity, but wf sets this
    end
    x == y
  end

  def diff(instances)
    res = {}
    initial_mem = region_env_alerts
    expected_by_name = instances.reduce(initial_mem){|mem, i| mem += alerts(i)}.map{|a| [a['name'], a]}.to_h
    wf_alerts = []
    FAM.each_value do |family|
      wf_alerts += fetch_alerts(family)
    end
    dups = wf_alerts.group_by{ |a| a['name'] }.select { |k, v| v.size > 1 }.map(&:first)
    raise "dups=#{dups}" unless dups.empty?
    actual_by_name = wf_alerts.map{|a| [a['name'], a]}.to_h

    unknown = actual_by_name.keys - expected_by_name.keys
    res[:to_delete] = actual_by_name.values_at(*(unknown)).compact

    recent = expected_by_name.keys - actual_by_name.keys
    res[:to_create] = expected_by_name.values_at(*(recent)).compact

    known = expected_by_name.keys & actual_by_name.keys
    res[:to_update] = []
    known.each do |name|
      # next unless name == "num of telegraf-raas pods in staging us-west-2"
      actual = actual_by_name[name]
      expected = expected_by_name[name]
      # puts JSON.pretty_generate actual
      # puts JSON.pretty_generate expected
      unless similar?(actual, expected)
        alert = expected.clone
        alert['id'] = actual['id']
        res[:to_update] << alert
      end
    end

    res
  end

  def update(diff)
    update_alerts(diff[:to_update])
    delete_alerts(diff[:to_delete])
    create_alerts(diff[:to_create])
  end

end