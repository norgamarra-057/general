json.extract! db, :id, :rl_id, :name, :engine, :status, :num_shards, :placement, :replication, :persistence, :endpoint_host, :endpoint_port, :cluster_id, :created_at, :updated_at
json.url db_url(db, format: :json)
