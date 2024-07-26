require 'networking.rb'

class OpsConfigInfo

  # We only need the OpsConfig::Host's "internal_ip" method.
  # This class acts as a OpsConfig::Host object, but setting only
  # the required attributes to run the method "internal_ip"
  class HostNetworking
    attr_reader :data_hash, :interfaces
    include Networking
    def initialize(host_data)
      @data_hash = host_data
      @interfaces = host_data['interfaces']
    end
  end

  # http://nagios.sourceforge.net/docs/3_0/objectdefinitions.html#contact
  @@notifymap = Hash[
    "critical", "c",
    "c", "c",
    "warning", "w",
    "w", "w",
    "recovery", "r",
    "r", "r",
    "ok", "r",
    "unknown", "u",
    "u", "u",
    "flapping", "f",
    "f", "f",
    "none", "n",
    "n", "n",
    "scheduled", "s",
    "s", "s",
    ]

  @@notify_hostmap = Hash[
    "down", "d",
    "d", "d",
    "unreachable", "u",
    "u", "u",
    "recovery", "r",
    "r", "r",
    "ok", "r",
    "flapping", "f",
    "f", "f",
    "none", "n",
    "n", "n",
    "scheduled", "s",
    "s", "s",
    ]

  def initialize(repo)
    @repo = repo
  end

  def create
    set_nagios_config_vars
    return {
      :contacts         => @contacts,
      :notifications    => @notifications,
      :contacts_host    => @contacts_host,
      :hostgroups       => @hostgroups,
      :services         => @services,
      :hosts            => @hosts,
      :nagios_clusters  => @nagios_clusters
    }
  end

  private

  def set_nagios_config_vars
    # generate maps for service and contact objects
    @notifications = {}
    @contacts = {}
    @contacts_host = {}
    @services = []
    @hosts = {}
    @hostgroups = {}
    @nagios_clusters = {}
    @repo.hosts.each do |fqdn, host|
      if host['params']['nagios']
        if host['params']['nagios']['monitored_host_hashes'] && host['params']['nagios']['cluster_id']
          nagios_cluster_id = host['params']['nagios']['cluster_id']
          @nagios_clusters[nagios_cluster_id] ||= {}
          @nagios_clusters[nagios_cluster_id][fqdn] = host['params']['nagios']['monitored_host_hashes']
        end
      end

      # set up hostgroup (monitoring_cluster)
      monitoring_cluster = host['params']['monitoring_cluster']
      @hostgroups[monitoring_cluster] = true if monitoring_cluster

      # set up host object
      @hosts[fqdn] = {
        "host_name" => fqdn,
        "address" => HostNetworking.new(host).internal_ip,
        "hostgroup" => monitoring_cluster,
        "vc" => host['hardware'] && host['hardware']["vc"],
      }
      ops_params = host['ops_params']
      ops_params ||= {}
      # add more ops_params from the hardware section
      ['vc', 'rack', 'vmhost', 'type'].each do |k|
        ops_params[k] = host['hardware'][k] if (host['hardware'] && host['hardware'][k])
      end
      @hosts[fqdn]["ops_params"] = ops_params unless ops_params.nil? or ops_params.empty?

      hostclass = @repo.get_hostclass(host['hostclass'])

      @hosts[fqdn]["contacts"] = nil
      (host['notify_host'] || []).each do |monitor_contact|
        add_nagios_config_contact_host(@hosts[fqdn], @contacts_host, @notifications, monitor_contact)
      end

      # set up service and contact objects, only when host define the monitoring_cluster
      if monitoring_cluster
        (hostclass['monitors'] || {}).merge(host['monitors'] || {}).each do |monitor, service_arr|
          service_arr = [service_arr] if service_arr.class == Hash
          service_arr.each do |s|
            service = s.dup
            # individual monitor
            # determine contact(s)
            service["contacts"] = nil
            (service["notify"] || host['notify'] || hostclass['notify'] || []).each do |monitor_contact|
              add_nagios_config_contact(service, @contacts, @notifications, monitor_contact)
            end

            # Setting logonly-contact when service['notify'] is explicitly false
            service["contacts"] = ['notify_logonly'] if service['notify'] == false
            if service["spoof_host"]
              spoofed_ip, spoofed_hostname = service["spoof_host"].split(":")
              @hosts[spoofed_hostname] = {
                "host_name" => spoofed_hostname,
                "address" => spoofed_ip,
                "hostgroup" => monitoring_cluster,
              } unless @hosts.has_key?(spoofed_hostname) # prefer specs from host file
              service["host_name"] = spoofed_hostname
            else
              service["host_name"] = fqdn
            end
            service["service_description"] = monitor
            service["hostgroup"] = monitoring_cluster
            if !service["servicegroup"]
              service["servicegroup"] = Array.new()
            elsif service["servicegroup"].is_a? String
              service["servicegroup"] = service["servicegroup"].split(/ *, */)
            end
            service["servicegroup"].push(monitoring_cluster + "-" + monitor)
            # number of consecutive non-OKs before alerting
            service["max_check_attempts"] ||= host["max_check_attempts"] || hostclass["max_check_attempts"]
            service["first_notification_delay"] ||= host["first_notification_delay"] || hostclass["first_notification_delay"]
            service["notification_interval"] ||= host["notification_interval"] || hostclass["notification_interval"]
            service["check_period"] ||= host["check_period"] || hostclass["check_period"]
            freshness_threshold = service["run_every"].to_i * 5
            service["freshness_threshold"] = service["freshness_threshold"] || freshness_threshold
            @services.push(service)
          end
        end
      end
    end
  end

  def add_nagios_config_contact_host(host, contacts_host, notifications, monitor_contact)
    if monitor_contact.is_a? String
      contact_email = monitor_contact
      smushed_contact = monitor_contact.gsub("@","AT")
      smushed_contact = smushed_contact.gsub('sreATgroupon.com','sre-alert-emailonlyATgroupon.com') # PRODTOOLS-213, line 1 of 3, hack until all instances of sre@groupon.com can be purged via hostclass tag&roll
    elsif monitor_contact.is_a? Hash
      notifiers = Array.new
      contact_email = monitor_contact.keys.first
      smushed_contact = contact_email.gsub("@", "AT")
      smushed_contact = smushed_contact.gsub('sreATgroupon.com','sre-alert-emailonlyATgroupon.com') # PRODTOOLS-213, line 2 of 3, hack until all instances of sre@groupon.com can be purged via hostclass tag&roll
      if monitor_contact[contact_email]["notify_on"]
        monitor_contact[contact_email]["notify_on"].each do |n|
          notifiers.push(@@notify_hostmap[n]) if @@notify_hostmap[n]
        end
        smushed_contact = contact_email.gsub("@", "AT") + "_h" + notifiers.sort.join
        smushed_contact = smushed_contact.gsub('sreATgroupon.com','sre-alert-emailonlyATgroupon.com') # PRODTOOLS-213, line 3 of 3, hack until all instances of sre@groupon.com can be purged via hostclass tag&roll
        notifications[smushed_contact] = notifiers.sort.join(",")
      end
    end
    contacts_host[smushed_contact] ||= contact_email
    host["contacts"] ||= []
    host["contacts"].push(smushed_contact)
  end

  def add_nagios_config_contact(service, contacts, notifications, monitor_contact)
    if monitor_contact.is_a? String
      contact_email = monitor_contact
      smushed_contact = monitor_contact.gsub("@","AT")
      smushed_contact = smushed_contact.gsub('sreATgroupon.com','sre-alert-emailonlyATgroupon.com') # PRODTOOLS-213, line 1 of 3, hack until all instances of sre@groupon.com can be purged via hostclass tag&roll
    elsif monitor_contact.is_a? Hash
      notifiers = Array.new
      contact_email = monitor_contact.keys.first
      smushed_contact = contact_email.gsub("@", "AT")
      smushed_contact = smushed_contact.gsub('sreATgroupon.com','sre-alert-emailonlyATgroupon.com') # PRODTOOLS-213, line 2 of 3, hack until all instances of sre@groupon.com can be purged via hostclass tag&roll
      if monitor_contact[contact_email]["notify_on"]
        monitor_contact[contact_email]["notify_on"].each do |n|
          notifiers.push(@@notifymap[n]) if @@notifymap[n]
        end
        smushed_contact = contact_email.gsub("@", "AT") + "_" + notifiers.sort.join
        smushed_contact = smushed_contact.gsub('sreATgroupon.com','sre-alert-emailonlyATgroupon.com') # PRODTOOLS-213, line 3 of 3, hack until all instances of sre@groupon.com can be purged via hostclass tag&roll
        notifications[smushed_contact] = notifiers.sort.join(",")
      end
    end
    contacts[smushed_contact] ||= contact_email
    service["contacts"] ||= []
    service["contacts"].push(smushed_contact)
  end

end