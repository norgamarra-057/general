require 'cgi'

module Utils

  def short_region
    case @aws_region
    when 'us-west-2'
      'usw2'
    when 'us-west-1'
      'usw1'
    when 'eu-west-1'
      'euw1'
    else
      raise "unknown region: #{@aws_region}"
    end
  end

  def wf_servers_wildcard(tfdata)
    dbname = tfdata[:cluster_name]
    if @engine == 'memcached'
      wc = "#{dbname}.*.*.#{short_region}.cache.amazonaws.com:11211"
    else
      wc = "#{dbname}-*.#{short_region}.cache.amazonaws.com"
    end
    wc
  end

  def dashboard_link(cluster)
    if @engine == 'redis'
      dbname = cluster[:cluster_name]
      "https://groupon.wavefront.com/dashboards/raas_aws_redis#(g:(d:7200,c:off,l:!t,ls:!t,w:'2h'),p:(role:(d:master,l:role,m:(master:master,slave:slave)),server:'#{wf_servers_wildcard(cluster)}',region:'#{@aws_region}',name:'#{dbname}'))"
    else
      "https://groupon.wavefront.com/dashboards/raas_aws_memcached#(g:(d:7200,c:off,l:!t,ls:!t,w:'2h'),p:(server:'#{wf_servers_wildcard(cluster)}'))"
    end
  end

  def alerts_link(cluster)
    # https://groupon.wavefront.com/alerts?search={"searchTerms":[{"type":"tags","value":"raas"},{"type":"tags","value":"dev"},{"type":"tags","value":"eu-west-1"},{"type":"tags","value":"memcached"},{"type":"tags","value":"autocreated"},{"type":"tags","value":"aws"},{"type":"freetext","value":"occasions-dev"}]}
    search = { "searchTerms" => [
      {"type" => "tags","value" => "raas"},
      {"type" => "tags","value" => "autocreated"},
      {"type" => "tags","value" => "aws"},
      {"type" => "tags","value" => @env},
      {"type" => "tags","value" => @aws_region},
      {"type" => "tags","value" => @engine},
      {"type" => "tags","value" => cluster[:tpl_name]} # instance class, e.g. orders
      ]}
    "https://groupon.wavefront.com/alerts?search=#{CGI::escape(search.to_json)}"
  end

  require 'open-uri'
  def pricing_offer_by_type(node_type)
    unless @pricing_offer_by_type
      # https://aws.amazon.com/blogs/aws/new-aws-price-list-api/
      pricing_json = URI.open('https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonElastiCache/current/index.json')
      pricing = JSON.parse(IO.read(pricing_json))
      @pricing_offer_by_type = pricing['products'].values.map{|p| ["#{p['attributes']['cacheEngine']}:#{p['attributes']['usagetype']}".downcase.sub('-nodeusage:',':'),
                                         p['attributes'].merge(pricing['terms']['OnDemand'][p['sku']].values.first['priceDimensions'].values.first)]}.to_h
      # 2.6.3 :008 > pricing_offer_by_type['redis:usw2:cache.t2.micro']
      #  => {"servicecode"=>"AmazonElastiCache",
      #   ...
      #   "memory"=>"0.555 GiB",
      #   "unit"=>"Hrs",
      #   "pricePerUnit"=>{"USD"=>"0.0170000000"},
      #   ...
    end
    rgn = @aws_region == 'eu-west-1' ? 'eu' : short_region # pricing API is messed up
    @pricing_offer_by_type["#{@engine}:#{rgn}:#{node_type}"]
  end

  def price_per_month(node_type, num_nodes, no_replica = false)
    p = pricing_offer_by_type(node_type)
    raise "unknown units #{p['unit']}" unless p['unit'] == 'Hrs'
    perunit = p['pricePerUnit']['USD'].to_f*24*30
    perunit * num_nodes * (@engine == 'redis' && @env != 'staging' && no_replica == false ? 2 : 1)
  end

  def allocable_mem(node_type)
    p = pricing_offer_by_type(node_type)
    raise "unknown memory unit: #{p['memory']}" unless p['memory'].end_with?(' GiB')
    memory = p['memory'].to_f*(1024**3)
    # https://confluence.groupondev.com/display/RED/Cloud+FAQ#CloudFAQ-HowmuchmemorydoesElasticacheactuallygivefordatastorage
    @engine == 'redis' ? memory*0.75 : memory - 100*(1024**2)
  end

  def nic(tfdata)
    capacity = {
      'cache.r5.24xlarge' => '25G',
      'cache.r5.12xlarge' => '10G',
      'cache.r5.4xlarge' => '5G',
      'cache.r5.2xlarge' => '2.5G',
      'cache.r5.xlarge' => '1.25G',
      'cache.r5.large' => '0.75G',
    }
    capacity[tfdata[:node_type]] || '0.5G'
  end

end