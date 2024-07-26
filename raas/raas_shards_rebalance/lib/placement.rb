class Placement

  # indices on arrays, ex:
  # nodes << %w(node:5 SNC2-R10-9)
  # shards << %w(redis:79 node:1 master 1-819)
  I_ID = 0 # works for both
  I_RACK = 1 # index in nodes
  I_NODE = 1 # index in shard
  I_ROLE = 2 # index in shard
  I_SLOTS = 3 # index in shard

  def initialize(dbname, nodes, shards)
    @dbname = dbname
    @nodes = nodes
    @shards = shards
    @orig = {}
    @shards.each do |s|
      slot = s[I_SLOTS]
      role = s[I_ROLE].to_sym
      @orig[slot] ||= {}
      @orig[slot][role] = {
        node_id: s[I_NODE],
        shard_id: s[I_ID],
        rack_id: rack(s[I_NODE]),
      }
    end
  end

  def rack(node_id)
    @nodes.detect{|n| n[I_ID] == node_id}[I_RACK]
  end

  def calculate_move
    move = {}
    # 1. spread master shards over the nodes in order
    n = 0
    @shards.each do |shard|
      next unless shard[I_ROLE] == 'master'
      move[shard[I_SLOTS]] = {master: @nodes[n][I_ID]}
      n = (n + 1) % @nodes.size
    end
    # 2. spread slaves shards over the nodes in order.
    @shards.each do |shard|
      next unless shard[I_ROLE] == 'slave'
      sorted_nodes = @nodes.sort_by { |n|
        # sort by: #shards, id (id < 10,000)
        10_000 * move.count{|k,v| v[:master] == n[I_ID] || v[:slave] == n[I_ID] } + n[I_ID].split(':').last.to_i
      }
      master_node_id = move[shard[I_SLOTS]][:master]
      master_node = @nodes.detect{|n| n[I_ID] == master_node_id}
      # pick the first node not in the same rack as the corresponding master
      ideal_node = sorted_nodes.detect{|n| n[I_RACK] != master_node[I_RACK]}
      raise "can't find ideal node for shard #{shard}" unless ideal_node
      move[shard[I_SLOTS]][:slave] = ideal_node[I_ID]
    end
    move
  end

  def add_migration_commands(move)
    move.each do |slot, m|
      orig = @orig[slot]
      cmds = []
      if m[:master] != orig[:master][:node_id] || m[:slave] != orig[:slave][:node_id]
        if m[:master] == orig[:slave][:node_id] && m[:slave] == orig[:master][:node_id]
          cmds << "failover db #{@dbname} shard #{orig[:master][:shard_id].split(':').last}"
        elsif m[:master] == orig[:master][:node_id] && m[:slave] != orig[:slave][:node_id]
          cmds << "migrate db #{@dbname} shard #{orig[:slave][:shard_id].split(':').last} target_node #{m[:slave].split(':').last}"
        elsif m[:slave] == orig[:slave][:node_id] &&
              m[:master] != orig[:master][:node_id] &&
              rack(m[:master]) == orig[:master][:rack_id]
          cmds << "migrate db #{@dbname} shard #{orig[:master][:shard_id].split(':').last} target_node #{m[:master].split(':').last}"
          cmds << "failover db #{@dbname} shard #{orig[:slave][:shard_id].split(':').last}"
        elsif m[:master] == orig[:slave][:node_id] &&
              m[:slave] != orig[:master][:node_id]
          cmds << "migrate db #{@dbname} shard #{orig[:master][:shard_id].split(':').last} target_node #{m[:slave].split(':').last}"
        elsif m[:slave] == orig[:master][:node_id] &&
              m[:master] != orig[:slave][:node_id]
          cmds << "migrate db #{@dbname} shard #{orig[:slave][:shard_id].split(':').last} target_node #{m[:master].split(':').last}"
          cmds << "failover db #{@dbname} shard #{orig[:master][:shard_id].split(':').last}"
        elsif ( m[:master] != orig[:master][:node_id] &&
                rack(m[:master]) == orig[:master][:rack_id] &&
                m[:slave] != orig[:slave][:node_id] &&
                rack(m[:slave]) != orig[:slave][:rack_id]
              ) ||
              ( m[:master] != orig[:master][:node_id] &&
                rack(m[:master]) == orig[:master][:rack_id] &&
                m[:slave] != orig[:slave][:node_id] &&
                rack(m[:slave]) == orig[:slave][:rack_id]
              )
          cmds << "migrate db #{@dbname} shard #{orig[:slave][:shard_id].split(':').last} target_node #{m[:slave].split(':').last}"
          cmds << "migrate db #{@dbname} shard #{orig[:master][:shard_id].split(':').last} target_node #{m[:master].split(':').last}"
          cmds << "failover db #{@dbname} shard #{orig[:slave][:shard_id].split(':').last}"
        else
          cmds << "migrate db #{@dbname} shard #{orig[:slave][:shard_id].split(':').last} target_node #{m[:master].split(':').last}"
          cmds << "migrate db #{@dbname} shard #{orig[:master][:shard_id].split(':').last} target_node #{m[:slave].split(':').last}"
        end
      end
      m[:migration_commands] = cmds
    end
  end

end