json.extract! shard, :id, :rl_id, :role, :slots, :used_memory, :status, :db_id, :node_id, :created_at, :updated_at
json.url shard_url(shard, format: :json)
