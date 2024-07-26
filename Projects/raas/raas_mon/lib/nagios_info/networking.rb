# copied from ~/git/ops-config-wizard/lib/ops_config/host/networking.rb
  module Networking

    def aliases
      ip, subnet_masklen, ip_options, mac = first_ip_config(first_interface_name)
      ip_options['hostnames'] if ip_options
    end

    def internal_ip
      ip, subnet_masklen, ip_options, mac = first_ip_config(first_interface_name)
      ip
    end

    def internal_mac
      ip, subnet_masklen, ip_options, mac = first_ip_config(first_interface_name)
      mac
    end

    def host_cidr(interface_name = first_interface_name)
      ip, subnet_masklen, ip_options, mac = first_ip_config(interface_name)
      subnet_masklen ? "#{ip}/#{subnet_masklen}" : ip
    end

    def get_interfaces
      interfaces.keys.inject(Hash.new) do |hash, interface_name|
        hash[interface_name] = host_cidr(interface_name)
        hash
      end
    end

    def ipmi_ip
      ip, subnet_masklen, ip_options, mac = first_ip_config('ipmi')
      ip
    end

    def ipmi_mac
      ip, subnet_masklen, ip_options, mac = first_ip_config('ipmi')
      mac
    end

    def all_ip_addresses
      interfaces.map do |interface_name, interface_values|
        all_ip_config(interface_name)
      end.flatten.compact.uniq.sort
    end

    private

    def parse_ip_instance(ip_instance)
      if ip_instance.is_a? String
        ip_subnet_masklen_string = ip_instance
      elsif ip_instance.is_a? Hash
        raise("not exactly 1 key in IP instance: #{ip_instance.inspect}") unless ip_instance.keys.count == 1
        ip_subnet_masklen_string = ip_instance.keys.sort.first
        ip_options = ip_instance[ip_subnet_masklen_string]
      else
        raise("invalid IP instance class: #{ip_instance.class}, for IP instance: #{ip_instance.inspect}")
      end
      ip, subnet_masklen = ip_subnet_masklen_string.split('/')
      [ip, subnet_masklen, ip_options]
    end

    def slave_mac_address(interface)
      if interface['slaves'].is_a?(Array)
        interface['slaves'].map do |slave|
          interfaces[slave]['mac']
        end.compact.first
      end
    end

    def bridge_mac_address(interface, interface_name)
      if interface['type'] && interface['type'].downcase == 'bridge'
        bridged_interface = interfaces.values.detect do |interface_params|
          interface_params['bridge'] == interface_name
        end
        mac ||= slave_mac_address bridged_interface
        mac ||= bridged_interface['mac']
      end
    end

    def first_ip_config(interface_name)
      interface = interfaces[interface_name]
      mac ||= interface['mac']
      mac ||= slave_mac_address interface
      mac ||= bridge_mac_address interface, interface_name

      ip, subnet_masklen, ip_options = parse_ip_instance interface['inet'].first if interface['inet']

      [ip, subnet_masklen, ip_options, mac]
    end

    def all_ip_config(interface_name)
      interface = interfaces[interface_name]

      ips = []
      if interface['inet']
        interface['inet'].each do |intf|
         ip, _subnet_masklen, _ip_options = parse_ip_instance intf
         ips << ip
        end
      end
      ips
    end

    def first_interface_name
      if data_hash['primary_interface'] && interfaces[data_hash['primary_interface']]
        data_hash['primary_interface']
      else
        interfaces.keys.sort.first
      end
    end
  end
