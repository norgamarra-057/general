require 'digest'

class Pages
  include Utils

  def initialize(aws_region:, env:, engine:, group:)
    @aws_region = aws_region
    @env = env
    @engine = engine
    @group = group
  end

  def secrets_link(i)
    if i[:cluster_name].end_with?('-prod')
      'https://github.groupondev.com/data/raas-secrets/blob/master/bast-k8s-secret-prod.yml'
    else
      'https://github.groupondev.com/data/raas-secrets/blob/master/bast-k8s-secret-nonprod.yml'
    end
  end

  def attributes_string(i)
    a = []
    if @engine == 'redis'
      if i[:OOMAlertsOptOut]
        if i[:param_group]
          # example: 'raas-redis5-cluster-allkeys-lru' -> allkeys-lru
          eviction_policy = i[:param_group].split('-')[-2..-1].join('-')
        else
          eviction_policy = 'volatile-lru'
        end
        a << eviction_policy
      else
        a << 'oomalerts'
      end
    end
    a << 'allow_onprem' if i[:allow_onprem]
    a << 'resque' if i[:resque]
    a.join(', ')
  end

  def dump_js(instances)
    data = instances.map do |i|
      [
        i[:cluster_name],
        @aws_region,
        "#{@engine} #{i[:engine_version]}",
        "<a target=\"_blank\" href=\"https://services.groupondev.com/services/#{i[:service]}\">#{i[:service]}</a>",
        i[:cname],
        i[:alias],
        "<a target=\"_blank\" href=\"https://jira.groupondev.com/browse/#{i[:ticket]}\">#{i[:ticket]}</a>",
        i[:node_type],
        i[:num_nodes],
        price_per_month(i[:node_type], i[:num_nodes], i[:no_replica]).to_i,
        "<a target=\"_blank\" href=\"#{dashboard_link(i)}\">📈</a>|<a target=\"_blank\" href=\"#{alerts_link(i)}\">🔥</a>",
        "<a target=\"_blank\" href=\"#{secrets_link(i)}\">#{i[:BastLevel]}</a>",
        attributes_string(i),
      ]
    end

    pages_dir = File.join(__dir__, "../../../docs/elasticache/")
    rel_path = "data/#{@engine}_#{@env}_#{@group}_#{short_region}.js"

    # write data-javascript file
    path = File.join(pages_dir, rel_path)
    File.open(path, 'w') do |file|
      file.write "var #{@engine}_#{@env}_#{@group}_#{short_region} = #{JSON.pretty_generate(data)};\n"
    end

    # set new hash on list.html to force browser reload
    sha256 = Digest::SHA256.file path
    short_sha = sha256.hexdigest[0..6]
    list_path = File.join(pages_dir, 'list.html')
    old_contents = File.read(list_path)
    new_contents = old_contents.gsub(/<script src=\"#{rel_path}\?v=.*$/, "<script src=\"#{rel_path}?v=#{short_sha}\"></script>")
    File.open(list_path, "w") {|file| file.write(new_contents) }
  end
end