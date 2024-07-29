#!/usr/bin/env ruby

require 'yaml'
require 'json'
require 'logger'

IPMAP_PATH  = File.join(__dir__, 'onprem_ipmap.yml')
INV_FILES   = File.join(__dir__, '..', 'inventory/group_vars/gds*.yml')
CATALOG_DIR = File.join(__dir__, '..', "docs/catalog/")
COLOS = ['snc1','sac1','dub1']
ENVS = ['prod','stg','test','uat']

$logger = Logger.new(STDOUT)

class Catalog

  def update
    @ipmap = YAML.load_file(IPMAP_PATH)
    instances = parse_instances
    IO.write(IPMAP_PATH, @ipmap.to_yaml)
    data = create_js_data(instances)
    js_file = "gds_onprem_instances.js"
    # write data-javascript file
    path = File.join(CATALOG_DIR, js_file)
    File.open(path, 'w') do |file|
      file.write "var gds_instances = #{JSON.pretty_generate(data)};\n"
    end
    # set new hash on onprem.html to force browser reload
    sha256 = Digest::SHA256.file path
    short_sha = sha256.hexdigest[0..6]
    list_path = File.join(CATALOG_DIR, 'onprem.html')
    old_contents = File.read(list_path)
    new_contents = old_contents.gsub(/<script src=\"#{js_file}\?v=.*$/, "<script src=\"#{js_file}?v=#{short_sha}\"></script>")
    File.open(list_path, "w") {|file| file.write(new_contents) }
  end

  def dashboard_link_instance(i, role)
    dc = i[:colo].upcase
    hostname = role == 'master' ? i[:nodes].first : i[:nodes].last
    if i[:type] == 'mysql'
      database = i[:name].gsub('_','.')
      env = "gds-#{i[:colo]}-#{i[:env]}"
      hostname = hostname.split('.').first # example: gds-snc1-prod-db021m1
      "https://groupon.wavefront.com/dashboards/gds_mysql_v2#(g:(d:7200,c:off,l:!t,ls:!t,w:'2h'),p:(database:(d:Label_2,f:METRIC_NAME,l:Database,m:(Label_14:#{database},Label_2:accounting.prod),s:Label_14),dc:(d:#{dc},l:DC,m:(DUB1:dub1,SAC1:sac1,SNC1:snc1),vo:!(DUB1,SAC1,SNC1)),env:(d:Label_2,f:SOURCE,k:env,l:Environment,m:(Label_2:demo-master.snc1,Label_5:#{env}),s:Label_5),host_new:(d:Label_2,f:SOURCE,l:Hostname,m:(Label_2:#{hostname})),port:(d:Label_2,f:METRIC_NAME,k:Port,l:Port,m:(Label_2:'#{i[:port]}'))))"
      # example: "https://groupon.wavefront.com/dashboards/gds_mysql_v2#(g:(d:7200,c:off,l:!t,ls:!t,w:'2h'),p:(database:(d:Label_2,f:METRIC_NAME,l:Database,m:(Label_14:audience.prod,Label_2:accounting.prod),s:Label_14),dc:(d:SNC1,l:DC,m:(DUB1:dub1,SAC1:sac1,SNC1:snc1),vo:!(DUB1,SAC1,SNC1)),env:(d:Label_2,f:SOURCE,k:env,l:Environment,m:(Label_2:demo-master.snc1,Label_5:gds-snc1-prod),s:Label_5),host_new:(d:Label_2,f:SOURCE,l:Hostname,m:(Label_2:gds-snc1-prod-db021m1)),port:(d:Label_2,f:METRIC_NAME,k:Port,l:Port,m:(Label_2:'20014'))))"
    else
      env = {'prod'=>'production','stg'=>'staging','uat'=>'uat'}[i[:env]]
      name = i[:name].chomp("_#{i[:env]}").gsub('_','.') # goods_price_serv_prod -> goods.price.serv
      "https://groupon.wavefront.com/dashboards/gds_postgres_detailed#(g:(d:7200,c:off,l:!t,ls:!t,w:'2h'),p:(dc:(d:#{dc},l:DC,m:(DUB1:dub1,SAC1:sac1,SNC1:snc1),vo:!(DUB1,SAC1,SNC1)),env:(d:#{env},l:Environment,m:(all:'*',production:prod,staging:stg,uat:uat),vo:!(all,uat,production,staging)),host:(d:Label_20,f:SOURCE,l:Hostname,m:(Label_20:#{hostname})),matchType:(d:Instance,l:Type,m:(Instance:'aliasMetric(ts(%22checkmk.PostgreSQL.*Daemon.Sessions.running%22%20and%20source=$%7Bhost%7D%20and%20az=$%7Bdc%7D),%20%20metric,%20%20%22checkmk.PostgreSQL.Port-.*.-.(.*).(uat%7Cstg%7Cprod).-.Daemon.Sessions.running%22,%20%20%22$1%22)',Port:'aliasMetric(ts(%22checkmk.PostgreSQL.Port-.*Size.size%22%20and%20source=$%7Bhost%7D%20and%20az=$%7Bdc%7D),%20metric,%20%22checkmk.PostgreSQL.Port-.(%5B0-9%5D+).*%22,%20%22$1%22)','Port%20(all)':'aliasMetric(ts(%22checkmk.PostgreSQL.Port-.*Size.size%22%20and%20source=$%7Bhost%7D%20and%20az=$%7Bdc%7D),%20metric,%20%22*%22,%20%22.*%22)'),vo:!(Instance,'Port%20(all)',Port)),pattern:(d:Label_10,f:METRIC_NAME,l:'-',m:(Label_10:metro.draft,Label_7:#{name}),q:'$%7BmatchType%7D',s:Label_7)))"
      # example: "https://groupon.wavefront.com/dashboards/gds_postgres_detailed#(g:(d:7200,c:off,l:!t,ls:!t,w:'2h'),p:(dc:(d:SNC1,l:DC,m:(DUB1:dub1,SAC1:sac1,SNC1:snc1),vo:!(DUB1,SAC1,SNC1)),env:(d:production,l:Environment,m:(all:'*',production:prod,staging:stg,uat:uat),vo:!(all,uat,production,staging)),host:(d:Label_20,f:SOURCE,l:Hostname,m:(Label_20:gds-snc1-prod-db054m1.snc1),q:'ts(%22checkmk.PostgreSQL.*$%7Benv%7D.-.Daemon.Sessions.running%22%20and%20az=$%7Bdc%7D)'),matchType:(d:Instance,l:Type,m:(Instance:'aliasMetric(ts(%22checkmk.PostgreSQL.*Daemon.Sessions.running%22%20and%20source=$%7Bhost%7D%20and%20az=$%7Bdc%7D),%20%20metric,%20%20%22checkmk.PostgreSQL.Port-.*.-.(.*).(uat%7Cstg%7Cprod).-.Daemon.Sessions.running%22,%20%20%22$1%22)',Port:'aliasMetric(ts(%22checkmk.PostgreSQL.Port-.*Size.size%22%20and%20source=$%7Bhost%7D%20and%20az=$%7Bdc%7D),%20metric,%20%22checkmk.PostgreSQL.Port-.(%5B0-9%5D+).*%22,%20%22$1%22)','Port%20(all)':'aliasMetric(ts(%22checkmk.PostgreSQL.Port-.*Size.size%22%20and%20source=$%7Bhost%7D%20and%20az=$%7Bdc%7D),%20metric,%20%22*%22,%20%22.*%22)'),vo:!(Instance,'Port%20(all)',Port)),pattern:(d:Label_10,f:METRIC_NAME,l:'-',m:(Label_10:metro.draft,Label_7:goods.price.serv),q:'$%7BmatchType%7D',s:Label_7)))"
    end
  end

  def alerts_link_instance(i)
    server = i[:env] == 'prod' ? 'checkmk-lvl3' : 'checkmk-staging'
    checkmkenv = i[:env] == 'prod' ? 'ber1_prod' : 'staging_snc1'
    "https://#{server}.groupondev.com/#{checkmkenv}/check_mk/index.py?start_url=%2F#{checkmkenv}%2Fcheck_mk%2Fview.py%3Ffilled_in%3Dfilter%26host_regex%3D%2528#{i[:nodes][0]}%257C#{i[:nodes][1]}%2529%26service_regex%3D#{i[:name]}%26view_name%3Dsearchsvc"
  end

  def create_js_data(instances)
    instances.map do |i|
      [
        i[:name],
        i[:type],
        i[:port],
        "<a target=\"_blank\" href=\"#{alerts_link_instance(i)}\">🔥</a>",
        "#{i[:master_vip]}<a target=\"_blank\" href=\"#{dashboard_link_instance(i,'master')}\">📈</a>",
        "#{i[:slave_vip]}<a target=\"_blank\" href=\"#{dashboard_link_instance(i,'slave')}\">📈</a>",
        "#{i[:nodes].join(',')}",
        i[:file],
      ]
    end
  end

  require 'resolv'
  def get_name_from_ip(ip)
    unless @ipmap[ip]
      @ipmap[ip] = Resolv.getname(ip)
      $logger.info "got name for: \"#{ip}\": #{@ipmap[ip]}"
    end
    @ipmap[ip]
  end

  def get_instance_info(data)
    master_vip = get_name_from_ip(data['master_vip'])
    slave_vip = get_name_from_ip(data['slave_vips'].first)
    if data['type'] == 'mysql'
      port = data['ports']['mysqld']
      nodes = data['nodes']
    else
      port = data['ports']['postgresql_raw']
      nodes = data['replication_ips'][0..1].map{|ip| get_name_from_ip(ip)}
    end
    {port: port, nodes: nodes, master_vip: master_vip, slave_vip: slave_vip}
  end

  def parse_instances
    res = []
    Dir.glob(INV_FILES).each do |f|
      begin
        _, colo, env, dbid = File.basename(f).split('.').first.split('_')
        next unless COLOS.include?(colo)
        next unless ENVS.include?(env)
        next unless dbid.start_with?('db')
        data = YAML.load_file(f)
        next unless data['gds_instances']
        data['gds_instances'].each do |k,v|
          begin
            res << { colo: colo, env: env, name: k, type: v['type'], file: File.basename(f)}.merge(get_instance_info(v))
          rescue
            $logger.error("get_instance_info name=#{k}")
            raise $!
          end
        end
      rescue
        $logger.error("parse_instances file=#{f}")
        raise $!
      end
    end
    res
  end

end

c = Catalog.new
c.update