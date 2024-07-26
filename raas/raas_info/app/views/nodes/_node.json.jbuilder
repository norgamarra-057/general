json.extract! node, :id, :rl_id, :role, :address, :hostname, :num_shards, :num_shards_max, :cores, :version, :rack, :status, :available_ram, :available_ram_max, :ram, :ram_max, :cluster_id, :created_at, :updated_at
json.url node_url(node, format: :json)
