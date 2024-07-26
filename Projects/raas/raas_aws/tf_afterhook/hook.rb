#!/usr/bin/env ruby

require 'logger'

libx = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(libx) unless $LOAD_PATH.include?(libx)
require 'utils'
require 'terraform'
require 'wavefront'
require 'sql'
require 'pages'

USAGE = "usage: #{$0} <terraform_path>\nExample: #{$0} ~/git/raas/raas_aws/terragrunt_live/dev_stable_usw2/redis"
ENV_USAGE = "remember to set WF_API_TOKEN\nExample: export WF_API_TOKEN=fj99adsf-awef-00af-n299-na39asdfnn21"

terraform_path = ARGV[0]
raise USAGE unless terraform_path
raise ENV_USAGE unless ENV['WF_API_TOKEN']

$logger = Logger.new(STDOUT)
# Force logger flush to stdout so we see the
#  prompt when run by terragrunt's after_hook:
$stdout.sync = true

tf = Terraform.new(terraform_path)

pages = Pages.new(aws_region: tf.aws_region, env: tf.env, engine: tf.engine, group: tf.group)
pages.dump_js(tf.instances)

write_sql_tmp_files(tf) # temporary solution

wf = Wavefront.new(aws_region: tf.aws_region, env: tf.env, engine: tf.engine, group: tf.group)

diff = wf.diff(tf.instances)
$logger.info("alerts_to_delete=#{diff[:to_delete].map{|a| a['name']}}")
$logger.info("alerts_to_create=#{diff[:to_create].map{|a| a['name']}}")
$logger.info("alerts_to_update=#{diff[:to_update].map{|a| a['name']}}")
unless diff[:to_delete].empty? &&
       diff[:to_create].empty? &&
       diff[:to_update].empty?
  print "Perform wavefront updates? [y/n] "
  abort('exit') unless STDIN.gets().strip == 'y'
  wf.update(diff)
end

script_path = File.join(File.dirname(__FILE__), 'git_status.bash')
puts %x[ #{script_path} ]

require 'json'
cmd = "aws --region #{tf.aws_region} sns list-subscriptions --query 'Subscriptions[? Endpoint==`raas-alerts@groupon.com` && contains(TopicArn, `raas-elasticache-#{tf.engine}-events-#{tf.env}`)]'"
out = %x[ #{cmd} ]
res = JSON.parse out
puts "❌ Please manually create a raas-alerts@groupon.com subscription to raas-elasticache-#{tf.engine}-events-#{tf.env} SNS (DATA-6852) ⚠️" if res.empty?
