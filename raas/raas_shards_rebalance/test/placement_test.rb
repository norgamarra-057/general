$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../lib/')
require 'placement.rb'

require 'minitest/autorun'

class TestPlacement < Minitest::Test

  DBNAME = 'test'

  def test_calculate_basic_move
    # algorithm:
    # 1. spread the masters over the nodes in order. Sort nodes by id
    # 2. spread the slaves over the nodes in order. Sort nodes by: number of shards, id
    nodes = []
    nodes << %w(node:1 SNC2-R10-1)
    nodes << %w(node:2 SNC2-R10-2)
    nodes << %w(node:3 SNC2-R10-3)
    shards = []
    shards << %w(redis:79 node:1 master 1-819)
    shards << %w(redis:80 node:2 slave 1-819)
    shards << %w(redis:88 node:1 master 820-1638)
    shards << %w(redis:87 node:2 slave 820-1638)
    shards << %w(redis:81 node:1 master 1639-2457)
    shards << %w(redis:82 node:2 slave 1639-2457)
    shards << %w(redis:84 node:1 master 2458-3276)
    shards << %w(redis:83 node:2 slave 2458-3276)
    shards << %w(redis:86 node:1 master 3277-4096)
    shards << %w(redis:85 node:2 slave 3277-4096)
    placement = Placement.new(DBNAME, nodes, shards)
    move = placement.calculate_move
    assert_equal("node:1", move['1-819'][:master]) # redis:79
    assert_equal("node:3", move['1-819'][:slave]) # redis:80
    assert_equal("node:2", move['820-1638'][:master]) # redis:88
    assert_equal("node:1", move['820-1638'][:slave]) # redis:87
    assert_equal("node:3", move['1639-2457'][:master]) # redis:81
    assert_equal("node:2", move['1639-2457'][:slave]) # redis:82
    assert_equal("node:1", move['2458-3276'][:master]) # redis:84
    assert_equal("node:3", move['2458-3276'][:slave]) # redis:83
    assert_equal("node:2", move['3277-4096'][:master]) # redis:86
    assert_equal("node:1", move['3277-4096'][:slave]) # redis:85
  end

  def test_calculate_ideal
    # algorithm:
    # 1. spread the masters over the nodes in order. Sort nodes by id
    # 2. spread the slaves over the nodes in order. Sort nodes by: number of shards, id
    nodes = []
    nodes << %w(node:1 SNC2-R10-6)
    nodes << %w(node:2 SNC2-R10-9)
    nodes << %w(node:3 SNC2-R10-3)
    nodes << %w(node:4 SNC2-R10-6)
    nodes << %w(node:5 SNC2-R10-9)
    shards = []
    shards << %w(redis:79 node:1 master 1-819)
    shards << %w(redis:80 node:2 slave 1-819)
    shards << %w(redis:88 node:1 master 820-1638)
    shards << %w(redis:87 node:2 slave 820-1638)
    shards << %w(redis:81 node:1 master 1639-2457)
    shards << %w(redis:82 node:2 slave 1639-2457)
    shards << %w(redis:84 node:1 master 2458-3276)
    shards << %w(redis:83 node:2 slave 2458-3276)
    shards << %w(redis:86 node:1 master 3277-4096)
    shards << %w(redis:85 node:2 slave 3277-4096)
    placement = Placement.new(DBNAME, nodes, shards)
    move = placement.calculate_move

    assert_equal("node:1", move['1-819'][:master]) # redis:79
    assert_equal("node:2", move['1-819'][:slave]) # redis:80
    assert_equal("node:2", move['820-1638'][:master]) # redis:88
    assert_equal("node:1", move['820-1638'][:slave]) # redis:87
    assert_equal("node:3", move['1639-2457'][:master]) # redis:81
    assert_equal("node:4", move['1639-2457'][:slave]) # redis:82
    assert_equal("node:4", move['2458-3276'][:master]) # redis:84
    assert_equal("node:3", move['2458-3276'][:slave]) # redis:83
    assert_equal("node:5", move['3277-4096'][:master]) # redis:86
    assert_equal("node:1", move['3277-4096'][:slave]) # redis:85
  end

  def test_calculate_ideal_contiguous_nodes_in_same_rack
    # algorithm:
    # 1. spread the masters over the nodes in order. Sort nodes by id
    # 2. spread the slaves over the nodes in order. Sort nodes by: number of shards, id
    # 2.a if the slave is on the same node or rack as its master's, use the next
    nodes = []
    nodes << %w(node:1 SNC2-R10-1)
    nodes << %w(node:2 SNC2-R10-1)
    nodes << %w(node:3 SNC2-R10-2)
    nodes << %w(node:4 SNC2-R10-3)
    nodes << %w(node:5 SNC2-R10-4)
    shards = []
    shards << %w(redis:79 node:1 master 1-819)
    shards << %w(redis:80 node:2 slave 1-819)
    shards << %w(redis:88 node:1 master 820-1638)
    shards << %w(redis:87 node:2 slave 820-1638)
    shards << %w(redis:81 node:1 master 1639-2457)
    shards << %w(redis:82 node:2 slave 1639-2457)
    shards << %w(redis:84 node:1 master 2458-3276)
    shards << %w(redis:83 node:2 slave 2458-3276)
    shards << %w(redis:86 node:1 master 3277-4096)
    shards << %w(redis:85 node:2 slave 3277-4096)
    placement = Placement.new(DBNAME, nodes, shards)
    move = placement.calculate_move
    assert_equal("node:1", move['1-819'][:master]) # redis:79
    assert_equal("node:3", move['1-819'][:slave]) # redis:80
    assert_equal("node:2", move['820-1638'][:master]) # redis:88
    assert_equal("node:4", move['820-1638'][:slave]) # redis:87
    assert_equal("node:3", move['1639-2457'][:master]) # redis:81
    assert_equal("node:1", move['1639-2457'][:slave]) # redis:82
    assert_equal("node:4", move['2458-3276'][:master]) # redis:84
    assert_equal("node:2", move['2458-3276'][:slave]) # redis:83
    assert_equal("node:5", move['3277-4096'][:master]) # redis:86
    assert_equal("node:1", move['3277-4096'][:slave]) # redis:85
  end

  def test_calculate_ideal_few_nodes
    # algorithm:
    # 1. spread the masters over the nodes in order. Sort nodes by id
    # 2. spread the slaves over the nodes in order. Sort nodes by: number of shards, id
    # 2.a if the slave is on the same node or rack as its master's, use the next
    nodes = []
    nodes << %w(node:1 SNC2-R10-1)
    nodes << %w(node:2 SNC2-R10-1)
    nodes << %w(node:3 SNC2-R10-2)
    shards = []
    shards << %w(redis:79 node:1 master 1-819)
    shards << %w(redis:80 node:2 slave 1-819)
    shards << %w(redis:88 node:1 master 820-1638)
    shards << %w(redis:87 node:2 slave 820-1638)
    shards << %w(redis:81 node:1 master 1639-2457)
    shards << %w(redis:82 node:2 slave 1639-2457)
    shards << %w(redis:84 node:1 master 2458-3276)
    shards << %w(redis:83 node:2 slave 2458-3276)
    shards << %w(redis:86 node:1 master 3277-4096)
    shards << %w(redis:85 node:2 slave 3277-4096)
    placement = Placement.new(DBNAME, nodes, shards)
    move = placement.calculate_move
    assert_equal("node:1", move['1-819'][:master]) # redis:79
    assert_equal("node:3", move['1-819'][:slave]) # redis:80
    assert_equal("node:2", move['820-1638'][:master]) # redis:88
    assert_equal("node:3", move['820-1638'][:slave]) # redis:87
    assert_equal("node:3", move['1639-2457'][:master]) # redis:81
    assert_equal("node:1", move['1639-2457'][:slave]) # redis:82
    assert_equal("node:1", move['2458-3276'][:master]) # redis:84
    assert_equal("node:3", move['2458-3276'][:slave]) # redis:83
    assert_equal("node:2", move['3277-4096'][:master]) # redis:86
    assert_equal("node:3", move['3277-4096'][:slave]) # redis:85
  end

  def test_calculate_ideal_impossible
    nodes = []
    nodes << %w(node:1 SNC2-R10-1)
    nodes << %w(node:2 SNC2-R10-1)
    nodes << %w(node:3 SNC2-R10-1)
    shards = []
    shards << %w(redis:79 node:1 master 1-819)
    shards << %w(redis:80 node:2 slave 1-819)
    shards << %w(redis:88 node:1 master 820-1638)
    shards << %w(redis:87 node:2 slave 820-1638)
    shards << %w(redis:81 node:1 master 1639-2457)
    shards << %w(redis:82 node:2 slave 1639-2457)
    shards << %w(redis:84 node:1 master 2458-3276)
    shards << %w(redis:83 node:2 slave 2458-3276)
    shards << %w(redis:86 node:1 master 3277-4096)
    shards << %w(redis:85 node:2 slave 3277-4096)
    placement = Placement.new(DBNAME, nodes, shards)
    assert_raises RuntimeError do
      placement.calculate_move
    end
  end

  def test_migration_commands
    # We start with master currently in node A, rack a
    #            and slave currently in node B, rack b
    # master slave
    #     Aa    Bb
    # We may need to move them to:
    # case 1) same nodes:
    #     Aa    Bb: no commands
    #     Bb    Aa: failover
    # case 2) one node moves:
    #     Aa    Cc: migrate slave
    #     Aa    Cb: migrate slave
    #     Cc    Bb: migrate slave to C, migrate master to B
    #     Ca    Bb: migrate master to C, failover
    #     Cc    Aa: migrate slave to C, failover
    #     Cb    Aa: migrate slave to C, failover
    #     Bb    Cc: migrate master to C
    #     Bb    Ca: migrate master to C
    # case 3) different nodes:
    #     Cc    Dd: migrate slave to C, migrate master to D
    #     Ca    Dd: migrate slave to D, migrate master to C, failover
    #     Cb    Dd: migrate slave to C, migrate master to D
    #     Cc    Da: migrate slave to C, migrate master to D
    #     Cc    Db: migrate slave to C, migrate master to D
    #     Ca    Db: migrate slave to D, migrate master to C, failover
    #     Cb    Da: migrate slave to C, migrate master to D

    nodes = []
    nodes << %w(node:1 SNC2-R10-1) # Aa
    nodes << %w(node:2 SNC2-R10-2) # Bb
    nodes << %w(node:3 SNC2-R10-3) # Cc
    nodes << %w(node:4 SNC2-R10-2) # Cb
    nodes << %w(node:5 SNC2-R10-1) # Ca
    nodes << %w(node:6 SNC2-R10-4) # Dd
    nodes << %w(node:7 SNC2-R10-1) # Da
    nodes << %w(node:8 SNC2-R10-2) # Db
    shards = []
    # set original locations
    shards << %w(redis:79 node:1 master 1-819)
    shards << %w(redis:80 node:2 slave 1-819)
    placement = Placement.new(DBNAME, nodes, shards)

    move = {}
    move['1-819'] = {}

    # case 1) same nodes:
    # no migration needed
    move['1-819'][:master] = 'node:1'
    move['1-819'][:slave] = 'node:2'
    placement.add_migration_commands(move)
    assert_equal([], move['1-819'][:migration_commands])
    # failover
    move['1-819'][:master] = 'node:2'
    move['1-819'][:slave] = 'node:1'
    placement.add_migration_commands(move)
    assert_equal(["failover db #{DBNAME} shard 79"], move['1-819'][:migration_commands])

    # case 2) one node moves:
    #     Aa    Cc: migrate slave
    move['1-819'][:master] = 'node:1'
    move['1-819'][:slave] = 'node:3'
    placement.add_migration_commands(move)
    assert_equal(["migrate db #{DBNAME} shard 80 target_node 3"], move['1-819'][:migration_commands])
    #     Aa    Cb: migrate slave
    move['1-819'][:master] = 'node:1'
    move['1-819'][:slave] = 'node:4'
    placement.add_migration_commands(move)
    assert_equal(["migrate db #{DBNAME} shard 80 target_node 4"], move['1-819'][:migration_commands])
    #     Cc    Bb: migrate slave to C, migrate master to B
    move['1-819'][:master] = 'node:3'
    move['1-819'][:slave] = 'node:2'
    placement.add_migration_commands(move)
    assert_equal(["migrate db #{DBNAME} shard 80 target_node 3", "migrate db #{DBNAME} shard 79 target_node 2"], move['1-819'][:migration_commands])
    #     Ca    Bb: migrate master to C, failover
    move['1-819'][:master] = 'node:5'
    move['1-819'][:slave] = 'node:2'
    placement.add_migration_commands(move)
    assert_equal(["migrate db #{DBNAME} shard 79 target_node 5", "failover db #{DBNAME} shard 80"], move['1-819'][:migration_commands])
    #     Cc    Aa: migrate slave to C, failover
    move['1-819'][:master] = 'node:3'
    move['1-819'][:slave] = 'node:1'
    placement.add_migration_commands(move)
    assert_equal(["migrate db #{DBNAME} shard 80 target_node 3", "failover db #{DBNAME} shard 79"], move['1-819'][:migration_commands])
    #     Cb    Aa: migrate slave to C, failover
    move['1-819'][:master] = 'node:4'
    move['1-819'][:slave] = 'node:1'
    placement.add_migration_commands(move)
    assert_equal(["migrate db #{DBNAME} shard 80 target_node 4", "failover db #{DBNAME} shard 79"], move['1-819'][:migration_commands])
    #     Bb    Cc: migrate master to C
    move['1-819'][:master] = 'node:2'
    move['1-819'][:slave] = 'node:3'
    placement.add_migration_commands(move)
    assert_equal(["migrate db #{DBNAME} shard 79 target_node 3"], move['1-819'][:migration_commands])
    #     Bb    Ca: migrate master to C
    move['1-819'][:master] = 'node:2'
    move['1-819'][:slave] = 'node:5'
    placement.add_migration_commands(move)
    assert_equal(["migrate db #{DBNAME} shard 79 target_node 5"], move['1-819'][:migration_commands])

    # case 3) different nodes:
    #     Cc    Dd: migrate slave to C, migrate master to D
    move['1-819'][:master] = 'node:3'
    move['1-819'][:slave] = 'node:6'
    placement.add_migration_commands(move)
    assert_equal(["migrate db #{DBNAME} shard 80 target_node 3", "migrate db #{DBNAME} shard 79 target_node 6"], move['1-819'][:migration_commands])
    #     Ca    Dd: migrate slave to D, migrate master to C, failover
    move['1-819'][:master] = 'node:5'
    move['1-819'][:slave] = 'node:6'
    placement.add_migration_commands(move)
    assert_equal(["migrate db #{DBNAME} shard 80 target_node 6", "migrate db #{DBNAME} shard 79 target_node 5", "failover db #{DBNAME} shard 80"], move['1-819'][:migration_commands])
    #     Cb    Dd: migrate slave to C, migrate master to D
    move['1-819'][:master] = 'node:4'
    move['1-819'][:slave] = 'node:6'
    placement.add_migration_commands(move)
    assert_equal(["migrate db #{DBNAME} shard 80 target_node 4", "migrate db #{DBNAME} shard 79 target_node 6"], move['1-819'][:migration_commands])
    #     Cc    Da: migrate slave to C, migrate master to D
    move['1-819'][:master] = 'node:3'
    move['1-819'][:slave] = 'node:7'
    placement.add_migration_commands(move)
    assert_equal(["migrate db #{DBNAME} shard 80 target_node 3", "migrate db #{DBNAME} shard 79 target_node 7"], move['1-819'][:migration_commands])
    #     Cc    Db: migrate slave to C, migrate master to D
    move['1-819'][:master] = 'node:3'
    move['1-819'][:slave] = 'node:8'
    placement.add_migration_commands(move)
    assert_equal(["migrate db #{DBNAME} shard 80 target_node 3", "migrate db #{DBNAME} shard 79 target_node 8"], move['1-819'][:migration_commands])
    #     Ca    Db: migrate slave to D, migrate master to C, failover
    move['1-819'][:master] = 'node:5'
    move['1-819'][:slave] = 'node:8'
    placement.add_migration_commands(move)
    assert_equal(["migrate db #{DBNAME} shard 80 target_node 8", "migrate db #{DBNAME} shard 79 target_node 5", "failover db #{DBNAME} shard 80"], move['1-819'][:migration_commands])
    #     Cb    Da: migrate slave to C, migrate master to D
    move['1-819'][:master] = 'node:4'
    move['1-819'][:slave] = 'node:7'
    placement.add_migration_commands(move)
    assert_equal(["migrate db #{DBNAME} shard 80 target_node 4", "migrate db #{DBNAME} shard 79 target_node 7"], move['1-819'][:migration_commands])
  end

end

