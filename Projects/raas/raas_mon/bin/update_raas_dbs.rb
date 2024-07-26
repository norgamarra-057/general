#!/usr/bin/env ruby

require 'json'
require 'mysql2'
require 'pg'
require 'logger'
require 'yaml'
require 'fileutils'

HOST_FILE = '/var/tmp/host.yml'
RLADMIN_STATUSES = '/var/groupon/raas_mon/rladmin_status_by_cluster.json'
# RLADMIN_STATUSES = 'test/fixtures/example_rladmin_status_by_cluster.json'

TABLES = %w(nodes dbs endpoints shards)

class MySQLRaaSUpdatesManager
  def initialize(db_client)
    @db_client = db_client
    @prep_tmp_insert = {}
  end
  def truncate_tmp_tables
    $logger.info "truncating tmp tables"
    TABLES.each do |table|
      sql = "TRUNCATE TABLE #{table}_tmp"
      @db_client.query(sql)
    end
  end
  # conn.prepare('statement1', 'insert into table1 (id, name, profile) values ($1, $2, $3)')
  # conn.exec_prepared('statement1', [ 11, 'J.R. "Bob" Dobbs', 'Too much is always better than not enough.' ])
  def tmp_insert(table, hash)
    unless @prep_tmp_insert[table] # prepare/cache one insert statement per table
      $logger.info "preparing insert statements for table #{table}"
      sql = "INSERT INTO #{table}_tmp(#{hash.keys.map{|k| '`'+k+'`'}.join(',')})
               VALUES(#{('?'*hash.size).split('').join(',')})" # VALUES(?,?,?...)
      @prep_tmp_insert[table] = @db_client.prepare(sql)
    end
    @prep_tmp_insert[table].execute(*hash.values) # ruby tip: '*' converts the array to a list of arguments
  end
  def swap_tmp_tables
    $logger.info "swapping tmp tables"
    # transaction:
    # ALTER TABLE new RENAME TO old;
    sql = "RENAME TABLE\n"
    rename_list = []
    TABLES.each do |table|
      rename_list << " #{table} TO #{table}_old, #{table}_tmp TO #{table}, #{table}_old TO #{table}_tmp"
    end
    sql << rename_list.join(",\n")
    @db_client.query(sql)
  end
end

class PostgresRaaSUpdatesManager
  def initialize(db_client)
    @db_client = db_client
    @prep_tmp_insert = {}
  end
  def truncate_tmp_tables
    $logger.info "truncating tmp tables"
    @db_client.transaction do |conn|
      TABLES.each do |table|
        sql = "TRUNCATE TABLE #{table}_tmp"
        conn.exec(sql)
      end
    end
  end
  # conn.prepare('statement1', 'insert into table1 (id, name, profile) values ($1, $2, $3)')
  # conn.exec_prepared('statement1', [ 11, 'J.R. "Bob" Dobbs', 'Too much is always better than not enough.' ])
  def tmp_insert(table, hash)
    unless @prep_tmp_insert[table] # prepare/cache one insert statement per table
      $logger.info "preparing insert statements for table #{table}"
      seq = *(1..hash.size)
      values = seq.map{|n| "$#{n}"}.join(',') # $1, $2, $3 ...
      sql = "INSERT INTO #{table}_tmp(#{hash.keys.join(',')})
               VALUES(#{values})"
      @db_client.prepare("tmp_insert_#{table}", sql)
      @prep_tmp_insert[table] = true
    end
    @db_client.exec_prepared("tmp_insert_#{table}", hash.values) # ruby tip: '*' converts the array to a list of arguments
  end
  def swap_tmp_tables
    $logger.info "swapping tmp tables"
    @db_client.transaction do |conn|
      TABLES.each do |table|
        conn.exec("ALTER TABLE #{table} RENAME TO #{table}_old")
        conn.exec("ALTER TABLE #{table}_tmp RENAME TO #{table}")
        conn.exec("ALTER TABLE #{table}_old RENAME TO #{table}_tmp")
      end
    end
  end
end

class Updater

  TABLE_NAME_MAP = {
    'CLUSTER NODES' => 'nodes',
    'DATABASES' => 'dbs',
    'ENDPOINTS' => 'endpoints',
    'SHARDS' => 'shards',
  }

  def initialize(db_manager, rladmin_status_by_cluster)
    @db_manager = db_manager
    @rladmin_status_by_cluster = rladmin_status_by_cluster
  end

  def update
    $logger.info "updating db"
    @db_manager.truncate_tmp_tables
    @rladmin_status_by_cluster.each do |cluster_name, rladmin_status|
      rladmin_status.each do |k, info_arr|
        table = TABLE_NAME_MAP[k]
        $logger.info "#{cluster_name}: inserting #{table}"
        info_arr.each do |info|
          row = create_row(table, cluster_name, info)
          @db_manager.tmp_insert(table, row)
        end
      end
    end
    @db_manager.swap_tmp_tables
    $logger.info "db updated successfully"
  end

  def create_row(table, cluster_name, info)
    row = {}
    row['cluster_name'] = cluster_name
    case table
    when 'nodes'
      row['id'] = info['NODE:ID']['node:'.size..-1] # remove the "node:" prefix
      row['role'] = info['ROLE']
      row['address'] = info['ADDRESS']
      row['hostname'] = info['HOSTNAME']
      row['shards'], row['shards_max'] = info['SHARDS'].split('/')
      row['cores'] = info['CORES']
      row['version'] = info['VERSION']
      row['rack'] = info['RACK-ID']
      row['status'] = info['STATUS']
      row['available_ram'] = to_bytes((info['AVAILABLE_RAM'] || info['FREE_RAM']).split('/').first) # ex: 3.26GB/5.76GB -> 3,260,000,000
      row['available_ram_max'] = to_bytes((info['AVAILABLE_RAM'] || info['FREE_RAM']).split('/').last) # ex: 3.26GB/5.76GB -> 5,760,000,000
      row['ram'] = nil
      row['ram_max'] = nil
      if info['RAM']
        row['ram'] = to_bytes(info['RAM'].split('/').first) # ex: 4.98GB/7.19GB -> 4,980,000,000
        row['ram_max'] = to_bytes(info['RAM'].split('/').last) # ex: 4.98GB/7.19GB -> 7,190,000,000
      end
    when 'dbs'
      row['id'] = info['DB:ID']['db:'.size..-1] # ex: remove the "db:" prefix
      row['name'] = info['NAME']
      row['type'] = info['TYPE']
      row['status'] = info['STATUS']
      row['shards'] = info['SHARDS']
      row['placement'] = info['PLACEMENT']
      row['replication'] = info['REPLICATION']
      row['persistence'] = info['PERSISTENCE']
      row['endpoint_host'], row['endpoint_port'] = info['ENDPOINT'].split(':')
    when 'endpoints'
      row['db_id'] = info['DB:ID']['db:'.size..-1] # remove the "db:" prefix
      row['db_name'] = info['NAME']
      row['id'] = info['ID']['endpoint:'.size..-1] # remove the "endpoint:" prefix
      row['node'] = info['NODE']['node:'.size..-1] # remove the "node:" prefix
      row['role'] = info['ROLE']
      row['ssl'] = info['SSL']
    when 'shards'
      row['db_id'] = info['DB:ID']['db:'.size..-1] # remove the "db:" prefix
      row['db_name'] = info['NAME']
      row['id'] = info['ID']['redis:'.size..-1] # remove the "redis:" prefix
      row['node'] = info['NODE']['node:'.size..-1] # remove the "node:" prefix
      row['role'] = info['ROLE']
      row['slots'] = info['SLOTS']
      row['used_memory'] = to_bytes(info['USED_MEMORY'])
      row['status'] = info['STATUS']
    end
    row
  end

  def to_bytes(str) # ex: 5.6GB -> 5600000000
    num = str.to_f # ex: 5.6GB -> 5.6
    res = (num * 1000 if str.include?('K')) ||
      (num * 1000_000 if str.include?('M')) ||
        (num * 1000_000_000 if str.include?('G')) ||
          (num * 1000_000_000_000 if str.include?('T')) || num
    res.to_i
  end

end

$logger = Logger.new(STDOUT)
begin
  host = YAML.load_file(HOST_FILE)
  if host['params']['raas_mysql']
    rladmin_status_by_cluster = JSON.parse IO.read(RLADMIN_STATUSES)

    $logger.info("update MySQL")
    mysql_client = Mysql2::Client.new(
      host: host['params']['raas_mysql']['host'],
      port: host['params']['raas_mysql']['port'],
      username: host['params']['raas_mysql']['user'],
      password: host['params']['raas_mysql']['password'],
      database: host['params']['raas_mysql']['database'],
    )
    db_manager = MySQLRaaSUpdatesManager.new(mysql_client)
    updater = Updater.new(db_manager, rladmin_status_by_cluster)
    updater.update

    $logger.info("update PostgreSQL")
    # POSTGRES
    conn = PG.connect( host: 'stg-raas2-mon-rw-vip.us.daas.grpn',
      port: 15432,
      user: 'raasmon2_stg_dba',
      password: 'd83j47ghsa92krn42pzi',
      dbname: 'raasmon2_stg',
      options: '--search_path=raasmon2' )
    db_manager = PostgresRaaSUpdatesManager.new(conn)
    updater = Updater.new(db_manager, rladmin_status_by_cluster)
    updater.update

  else
    $logger.info "host['params']['raas_mysql'] not found"
  end
  FileUtils.touch '/tmp/touched_by_update_raas_mysql_when_run_successfully'
rescue
  $logger.error $!
end

__END__

-- mysql/postgres setup:

DROP TABLE nodes;
CREATE TABLE nodes(
  cluster_name VARCHAR(100) NOT NULL,
  id INT NOT NULL,
  role VARCHAR(50),
  address VARCHAR(50),
  hostname VARCHAR(100),
  shards INT,
  shards_max INT,
  cores INT,
  version VARCHAR(50),
  rack VARCHAR(50),
  status VARCHAR(100),
  available_ram BIGINT,
  available_ram_max BIGINT,
  ram BIGINT,
  ram_max BIGINT
  );
CREATE INDEX nodes_index_cluster_name on nodes(cluster_name);
CREATE INDEX nodes_index_id on nodes(id);
CREATE INDEX nodes_index_role on nodes(role);
DROP TABLE nodes_tmp;
-- mysql:
CREATE TABLE nodes_tmp LIKE nodes;
-- postgres:
CREATE TABLE nodes_tmp (LIKE nodes INCLUDING ALL);


DROP TABLE dbs;
CREATE TABLE dbs (
  cluster_name VARCHAR(100) NOT NULL,
  id INT NOT NULL,
  name VARCHAR(100),
  type VARCHAR(50),
  status VARCHAR(50),
  shards INT,
  placement VARCHAR(50),
  replication VARCHAR(50),
  persistence VARCHAR(50),
  endpoint_host VARCHAR(100),
  endpoint_port INT
  );
CREATE INDEX dbs_index_cluster_name on dbs(cluster_name);
CREATE INDEX dbs_index_id on dbs(id);
CREATE INDEX dbs_index_type on dbs(type);
DROP TABLE dbs_tmp;
-- mysql:
CREATE TABLE dbs_tmp LIKE dbs;
-- postgres:
CREATE TABLE dbs_tmp (LIKE dbs INCLUDING ALL);

DROP TABLE endpoints;
CREATE TABLE endpoints (
  cluster_name VARCHAR(100) NOT NULL,
  id VARCHAR(50) NOT NULL,
  db_id INT NOT NULL,
  db_name VARCHAR(100),
  node INT,
  role VARCHAR(50),
  `ssl` VARCHAR(50)
  );
CREATE INDEX endpoints_index_cluster_name on endpoints(cluster_name);
CREATE INDEX endpoints_index_id on endpoints(id);
CREATE INDEX endpoints_index_db_id on endpoints(db_id);
CREATE INDEX endpoints_index_role on endpoints(role);
DROP TABLE endpoints_tmp;
-- mysql:
CREATE TABLE endpoints_tmp LIKE endpoints;
-- postgres:
CREATE TABLE endpoints_tmp (LIKE endpoints INCLUDING ALL);

DROP TABLE shards;
CREATE TABLE shards (
  cluster_name VARCHAR(100) NOT NULL,
  id INT NOT NULL,
  db_id INT NOT NULL,
  db_name VARCHAR(100),
  node INT,
  role VARCHAR(50),
  slots VARCHAR(50),
  used_memory BIGINT,
  status VARCHAR(100)
  );
CREATE INDEX shards_index_cluster_name on shards(cluster_name);
CREATE INDEX shards_index_id on shards(id);
CREATE INDEX shards_index_db_id on shards(db_id);
CREATE INDEX shards_index_node on shards(node);
CREATE INDEX shards_index_role on shards(role);
DROP TABLE shards_tmp;
-- mysql:
CREATE TABLE shards_tmp LIKE shards;
-- postgres:
CREATE TABLE shards_tmp (LIKE shards INCLUDING ALL);
