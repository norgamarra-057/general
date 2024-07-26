# library files from nagios_info project
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../lib/nagios_info')
require 'ops_config_info'

FAKE_HOSTNAME = 'fake123.i.do.not.exist'

class NagiosInfo

  attr_reader :info

  INFO_PATH = '/var/groupon/raas_mon/raas_nagios.info'

  def initialize(host)
    fake_repo = FakeRepo.new(host)
    nagios_info = OpsConfigInfo.new(fake_repo)
    info = nagios_info.create
    # keep only basic keys (drop conflicting keys (e.g. nagios_clusters))
    @info = {}
    @info['hosts'] = info[:hosts]
    @info['hosts'].delete(FAKE_HOSTNAME)
    @info['contacts'] = info[:contacts]
    @info['notifications'] = info[:notifications]
    @info['hostgroups'] = info[:hostgroups]
    @info['services'] = info[:services].delete_if{|s| !s['service_description'].start_with?('rlec_')}
  end

  def save
    tmp_path = "#{INFO_PATH}.#{$$}"
    $logger.info "event=writing_tmp_output path=#{tmp_path}"
    IO.write(tmp_path, @info.to_json)
    $logger.info "event=moving_tmp_to_permanent path=#{INFO_PATH}"
    FileUtils.mv tmp_path, INFO_PATH
    res = %x[gzip --to-stdout #{INFO_PATH} > #{tmp_path}.gz]
    if $?.exitstatus!=0
      $logger.error "event=gzip_failed exitstatus=#{$?.exitstatus} path=#{INFO_PATH}"
      raise res
    end
    gz_output_path = "#{INFO_PATH}.gz"
    $logger.info "event=moving_tmp_to_permanent path=#{gz_output_path}"
    FileUtils.mv "#{tmp_path}.gz", gz_output_path
  end
end

class FakeRepo

  def initialize(host)
    @host = host
  end
  def get_hostclass(tag)
    {}
  end
  def hosts
    {FAKE_HOSTNAME => @host}
  end
end
