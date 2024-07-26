#!/usr/bin/env ruby

require 'logger'
require 'yaml'
require 'open-uri'
require 'json'
require 'fileutils'

USAGE = "usage: #{$0} <terraform_path>\nExample: #{$0} ~/git/raas/raas_aws/terragrunt_live/dev_stable_usw2/redis"

terraform_path = ARGV[0]
raise USAGE unless terraform_path

$logger = Logger.new(STDOUT)
# Force logger flush to stdout so we see the
#  prompt when run by terragrunt's before_hook:
$stdout.sync = true

class AutoscalingMess

  def initialize(terraform_path)
    @terraform_path = terraform_path
  end

  def fix
    to_review = instances_to_review
    path_in = File.join(@terraform_path, 'instances.auto.tfvars')
    path_out = File.join(@terraform_path, 'instances.auto.tfvars.new')
    File.open(path_out, 'w') do |file|
      fixing = nil
      fixed = 0
      IO.readlines(path_in).each do |line|
        if line =~ /^redis-(.*) = {$/ && to_review[$1]
          fixing = $1
        end
        if line =~ / num_nodes = / && fixing
          cur_num_nodes = to_review[fixing]
          expected_line = "  num_nodes = #{cur_num_nodes}\n"
          if line != expected_line
            line = expected_line
            $logger.info("fixed: #{fixing}")
            fixed += 1
          end
          fixing = nil
        end
        file.write(line)
      end
      $logger.info("total fixed: #{fixed}")
    end
    FileUtils.mv path_out, path_in
  end

  def instances_to_review
    autoscaling_instances = github_get_autoscaling_instances

    aws_region = get_aws_region
    short_env = get_short_env
    instance_nodes = api_instance_nodes(short_env, aws_region)

    to_review = instance_nodes.slice(*autoscaling_instances)
    $logger.info("to_review: #{to_review.size}")
    to_review
  end

  def github_get_autoscaling_instances
    url = "https://raw.github.groupondev.com/data/raas_terraform_modules/master/source/redis_instances.yml"
    $logger.info("calling github: #{url}")
    instances = YAML.load(URI.open(url))
    res = instances.select{|k,v| v['autoscaling']}.keys
    $logger.info("autoscaling: #{res.size}")
    res
  end

  def api_instance_nodes(short_env, aws_region)
    cmd = "aws-okta exec #{short_env} -- aws --region #{aws_region} elasticache describe-replication-groups --query 'ReplicationGroups[*].{ID:ReplicationGroupId,NType:CacheNodeType,Nodes:length(MemberClusters)}'"
    $logger.info("calling AWS: #{cmd}")
    out = %x[ #{cmd} ]
    instances = JSON.parse out
    $logger.info("instances: #{instances.size}")
    instance_nodes = {}
    instances.each do |i|
      next if short_env=='dev' && !i['ID'].end_with?('dev')
      name = i['ID'].split('-')[0..-2].join('-') # my-redis-staging -> my-redis
      instance_nodes[name] = i['Nodes']/2
      instance_nodes[name] = i['Nodes'] if short_env=='stg' # RAAS-641 we removed replicas from stg
    end
    instance_nodes
  end

  def get_aws_region
    # ...terragrunt_live/stg_stable_usw1/redis/ -> usw1
    short_region = File.basename(File.dirname(@terraform_path))[-4..-1]
    case short_region
    when 'usw1'
      'us-west-1'
    when 'usw2'
      'us-west-2'
    when 'euw1'
      'eu-west-1'
    else
      raise "unknown short_region #{short_region}"
    end
  end

  def get_short_env
    # ...terragrunt_live/stg_stable_usw1/redis/ -> stg
    File.basename(File.dirname(@terraform_path))[0..2]
  end

end

mess = AutoscalingMess.new(terraform_path)
mess.fix
