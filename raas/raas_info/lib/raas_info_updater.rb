class RaaSInfoUpdater

  def initialize(rladmin_status_by_cluster, api_dbs_by_hostname)
    @rladmin_status_by_cluster = rladmin_status_by_cluster
    @api_dbs_by_hostname = api_dbs_by_hostname
    @current_clusters_by_name = {}
    @current_clusters_by_id = {}
    @current_nodes = {}
    @current_nodes_by_id = {}
    @current_dbs = {}
    @current_dbs_by_id = {}
  end

  def update
    update_clusters
    update_nodes
    update_databases
    update_endpoints
    update_shards
  end

  def update_clusters
    Rails.logger.info  "update_clusters"
    @current_clusters_by_name = {}
    @current_clusters_by_id = {}
    @rladmin_status_by_cluster.each do |cluster_name, rladmin_status|
      version = rladmin_status['CLUSTER NODES'].detect{ |info| info['ROLE']=='master' }['VERSION']
      @current_clusters_by_name[cluster_name] = Cluster.new(name: cluster_name, version: version)
    end
    Cluster.find_each do |cluster|
      current_cluster = @current_clusters_by_name[cluster.name]
      if !current_cluster.nil?
        current_attribs = current_cluster.attributes.except('id', 'monitoring_cluster', 'created_at', 'updated_at')
        saved_attribs = cluster.attributes.except('id', 'monitoring_cluster', 'created_at', 'updated_at')
        cluster.update(current_attribs) if current_attribs != saved_attribs
        @current_clusters_by_name[cluster.name] = cluster
        @current_clusters_by_id[cluster.id] = cluster
      else
        cluster.destroy
      end
    end
    @current_clusters_by_name.each do |cluster_name, cluster|
      unless cluster.id
        cluster.save
        @current_clusters_by_name[cluster.name] = cluster
        @current_clusters_by_id[cluster.id] = cluster
      end
    end
  end

  def update_nodes
    Rails.logger.info  "update_nodes"
    @rladmin_status_by_cluster.each do |cluster_name, rladmin_status|
      rladmin_status['CLUSTER NODES'].each do |info|
        node = Node.new do |n|
          n.rl_id = info['NODE:ID']['node:'.size..-1] # remove the "node:" prefix
          n.role = info['ROLE']
          n.address = info['ADDRESS']
          n.hostname = info['HOSTNAME']
          n.num_shards, n.num_shards_max = info['SHARDS'].split('/').map(&:to_i)
          n.cores = info['CORES']
          n.version = info['VERSION']
          n.rack = info['RACK-ID']
          n.status = info['STATUS']
          n.available_ram = to_bytes((info['AVAILABLE_RAM'] || info['FREE_RAM']).split('/').first) # ex: 3.26GB/5.76GB -> 3,260,000,000
          n.available_ram_max = to_bytes((info['AVAILABLE_RAM'] || info['FREE_RAM']).split('/').last) # ex: 3.26GB/5.76GB -> 5,760,000,000
          n.ram = nil
          n.ram_max = nil
          if info['RAM']
            n.ram = to_bytes(info['RAM'].split('/').first) # ex: 4.98GB/7.19GB -> 4,980,000,000
            n.ram_max = to_bytes(info['RAM'].split('/').last) # ex: 4.98GB/7.19GB -> 7,190,000,000
          end
          n.cluster = @current_clusters_by_name[cluster_name]
        end
        key = {cluster_name: cluster_name, rl_id: node.rl_id}
        @current_nodes[key] = node
      end
    end
    saved_objects = Node.all # ".all" avoids querying for associated clusters (we already have them)
    update_saved_objects_belonging_to_cluster(saved_objects, @current_nodes, @current_nodes_by_id)
  end

  def update_databases
    Rails.logger.info  "update_databases"
    @rladmin_status_by_cluster.each do |cluster_name, rladmin_status|
      proxy_policy_by_db_rl_id = {}
      rladmin_status['ENDPOINTS'].each do |info|
        proxy_policy_by_db_rl_id[info['DB:ID']] = info['ROLE']
      end
      rladmin_status['DATABASES'].each do |info|
        db = Db.new do |db|
          db.rl_id = info['DB:ID']['db:'.size..-1] # ex: remove the "db:" prefix
          db.name = info['NAME']
          db.engine = info['TYPE']
          db.status = info['STATUS']
          db.num_shards = info['SHARDS']
          db.placement = info['PLACEMENT']
          db.replication = info['REPLICATION']
          db.persistence = info['PERSISTENCE']
          db.endpoint_host, db.endpoint_port = info['ENDPOINT'].split(':')
          db.cluster = @current_clusters_by_name[cluster_name]
          db.proxy_policy = proxy_policy_by_db_rl_id[info['DB:ID']]
          api_db = @api_dbs_by_hostname[db.endpoint_host]
          raise "rladmin status db #{db.endpoint_host} not found in API" if api_db.nil?
          db.crdt_guid = api_db['crdt_guid']
          db.sync = api_db['sync']
          db.resque_web = api_db['resque_web']
          db.eviction_policy = api_db['eviction_policy']
          db.engine_version = api_db['version']
          db.memory_limit = api_db['memory_size']
          db.oss_cluster = api_db['oss_cluster']
        end
        key = {cluster_name: cluster_name, rl_id: db.rl_id}
        @current_dbs[key] = db
      end
    end
    saved_objects = Db.all # ".all" avoids querying for associated clusters (we already have them)
    update_saved_objects_belonging_to_cluster(saved_objects, @current_dbs, @current_dbs_by_id)
  end

  def update_endpoints
    Rails.logger.info  "update_endpoints"
    current_endpoints = {}
    @rladmin_status_by_cluster.each do |cluster_name, rladmin_status|
      rladmin_status['ENDPOINTS'].each do |info|
        db_rl_id = info['DB:ID']['db:'.size..-1].to_i # remove the "db:" prefix
        endpoint = Endpoint.new do |endpoint|
          endpoint.rl_id = info['ID']['endpoint:'.size..-1] # remove the "endpoint:" prefix
          endpoint.role = info['ROLE']
          endpoint.ssl = info['SSL']
          if info['NODE'].start_with?('node:')
            node_rl_id = info['NODE']['node:'.size..-1].to_i # remove the "node:" prefix
            node_key = {cluster_name: cluster_name, rl_id: node_rl_id}
            endpoint.node = @current_nodes[node_key]
          end
          db_key = {cluster_name: cluster_name, rl_id: db_rl_id}
          endpoint.db = @current_dbs[db_key]
        end
        key = {db_id: endpoint.db.id, rl_id: endpoint.rl_id}
        current_endpoints[key] = endpoint
      end
    end
    saved_objects = Endpoint.all # ".all" avoids querying for associated dbs and nodes (we already have them)
    update_saved_objects_belonging_to_db_and_node(saved_objects, current_endpoints)
  end

  def update_shards
    Rails.logger.info  "update_shards"
    current_shards = {}
    @rladmin_status_by_cluster.each do |cluster_name, rladmin_status|
      rladmin_status['SHARDS'].each do |info|
        shard = Shard.new do |shard|
          shard.rl_id = info['ID']['redis:'.size..-1] # remove the "redis:" prefix
          shard.role = info['ROLE']
          shard.slots = info['SLOTS']
          shard.used_memory = to_bytes(info['USED_MEMORY'])
          shard.status = info['STATUS']
          node_rl_id = info['NODE']['node:'.size..-1].to_i # remove the "node:" prefix
          node_key = {cluster_name: cluster_name, rl_id: node_rl_id}
          shard.node = @current_nodes[node_key]
          db_rl_id = info['DB:ID']['db:'.size..-1].to_i # remove the "db:" prefix
          db_key = {cluster_name: cluster_name, rl_id: db_rl_id}
          shard.db = @current_dbs[db_key]
        end
        key = {db_id: shard.db.id, rl_id: shard.rl_id}
        current_shards[key] = shard
      end
    end
    saved_objects = Shard.all # ".all" avoids querying for associated dbs and nodes (we already have them)
    update_saved_objects_belonging_to_db_and_node(saved_objects, current_shards)
  end

  def update_saved_objects_belonging_to_cluster(saved_objects, current_objects, current_objects_by_id)
    saved = Set.new
    saved_objects.each do |saved_obj|
      saved_obj.cluster = @current_clusters_by_id[saved_obj.cluster_id]
      key = {cluster_name: saved_obj.cluster.name, rl_id: saved_obj.rl_id}
      current_obj = current_objects[key]
      if current_obj
        current_attribs = current_obj.attributes.except('id', 'cluster_id', 'created_at', 'updated_at', 'team', 'service')
        saved_attribs = saved_obj.attributes.except('id', 'cluster_id', 'created_at', 'updated_at', 'team', 'service')
        saved_obj.update(current_attribs) if current_attribs != saved_attribs
        current_objects[key] = saved_obj # this is the most complete object
        saved.add(key)
      else
        saved_obj.destroy
      end
    end
    current_objects.each do |key, current_obj|
      current_obj.save unless saved.include?(key)
      current_objects_by_id[current_obj.id] = current_obj
    end
  end

  def update_saved_objects_belonging_to_db_and_node(saved_objects, current_objects)
    saved = Set.new
    saved_objects.each do |saved_obj|
      saved_obj.db = @current_dbs_by_id[saved_obj.db_id]
      saved_obj.node = @current_nodes_by_id[saved_obj.node_id] if saved_obj.node_id
      key = {db_id: saved_obj.db.id, rl_id: saved_obj.rl_id}
      current_saved_obj = current_objects[key]
      if current_saved_obj
        current_attribs = current_saved_obj.attributes.except('id', 'db_id', 'created_at', 'updated_at')
        saved_attribs = saved_obj.attributes.except('id', 'db_id', 'created_at', 'updated_at')
        saved_obj.update(current_attribs) if current_attribs != saved_attribs
        saved.add(key)
      else
        saved_obj.destroy
      end
    end
    current_objects.each do |key, current_obj|
      unless saved.include?(key)
        current_obj.save
      end
    end
  end

  def to_bytes(str) # ex: 5.6GB -> 5600000000
    num = str.to_f # ex: 5.6GB -> 5.6
    (num * 1000 if str.include?('K')) ||
      (num * 1000_000 if str.include?('M')) ||
        (num * 1000_000_000 if str.include?('G')) ||
          (num * 1000_000_000_000 if str.include?('T')) || num
  end

end
