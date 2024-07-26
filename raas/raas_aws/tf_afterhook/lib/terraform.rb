require 'rhcl'
require 'yaml'

class Terraform

  attr_reader :env, :group, :aws_region, :engine, :instances

  def initialize(terraform_path)
    @engine = File.basename(terraform_path)
    parent_path = File.dirname(terraform_path)
    raas_tfvars = Rhcl.parse(IO.read(File.join(parent_path, 'raas.tfvars')))
    @env = raas_tfvars['env']
    @group = raas_tfvars['group']

    vpc_tfvars = Rhcl.parse(IO.read(File.join(parent_path,'vpc.tfvars')))
    @aws_region = vpc_tfvars['aws_region']

    @instances_mod = YAML.load(URI.open("https://raw.github.groupondev.com/data/raas_terraform_modules/master/source/#{@engine}_instances.yml"))

    path = File.join(terraform_path, 'instances.auto.tfvars')
    hclstr = IO.read(path).strip
    @instances_tfvars = {}
    @instances_tfvars.merge!(Rhcl.parse(hclstr)) unless hclstr.empty?

    @instances = create_instances()
  end

  def create_instances()
    instances = []
    @instances_tfvars.each do |k,v|
      next unless v.is_a?(Hash)
      next unless v['create']
      # example key: memcached-occasions
      instance = {}
      instance[:tpl_name] = k[@engine.size+1..-1]
      instance[:cluster_name] = instance[:tpl_name] + '-' + @env
      instance[:ticket] = v['ticket']
      instance[:num_nodes] = v['num_nodes'] || 1 # single redis don't specify num_nodes
      instance[:node_type] = v['node_type']
      instance[:oom_thresholds] = v['oom_thresholds']
      instance[:no_replica] = v['no_replica'] || false # this field is for the github page and cost estimation only 

      add_module_info(instance)
      instances << instance
    end
    instances
  end

  def add_module_info(instance)
    key = instance[:tpl_name]
    info = @instances_mod[key]
    instance[:engine_version] = info['version']
    instance[:service] = info['service']
    instance[:autoscaling] = info['autoscaling']
    instance[:BastLevel] = info['bast']
    instance[:OOMAlertsOptOut] = !info['oomalert']
    instance[:allow_onprem] = info['allow'] && info['allow'].include?('onprem')
    instance[:param_group] = info['param_group']
    instance[:resque] = info['resque']
    instance[:data_tiering] = info['data_tiering']
    if @engine == 'redis'
      instance[:alias] = "#{info['dnsalias'] || key}--redis.#{@env}"
    else
      instance[:alias] = "#{info['dnsalias'] || key}--cache.#{@env}.service"
    end
    account = @env == "prod" ? 'prod' : 'stable'
    instance[:cname] = "#{instance[:alias]}.#{account}.#{@aws_region}.aws.groupondev.com"
    # badges-service-cloud--redis.staging
    # badges-service-cloud--redis.staging.stable.us-west-1.aws.groupondev.com
    # accounting-service--redis.prod
    # accounting-service--redis.prod.prod.us-west-1.aws.groupondev.com
    # awx-a-agent1--cache.staging.service
    # awx-a-agent1--cache.staging.service.stable.us-west-1.aws.groupondev.com
    # awx-a-infosec-agent1--cache.prod.service
    # awx-a-infosec-agent1--cache.prod.service.prod.us-west-1.aws.groupondev.com
  end

end
