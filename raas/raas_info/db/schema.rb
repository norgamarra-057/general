# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190528211824) do

  create_table "clusters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "monitoring_cluster"
    t.string "version"
    t.index ["name"], name: "index_clusters_on_name", unique: true
  end

  create_table "dbs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "rl_id"
    t.string "name"
    t.string "engine"
    t.string "status"
    t.integer "num_shards"
    t.string "placement"
    t.string "replication"
    t.string "persistence"
    t.string "endpoint_host"
    t.integer "endpoint_port"
    t.bigint "cluster_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "proxy_policy"
    t.string "crdt_guid"
    t.string "sync"
    t.string "resque_web"
    t.string "eviction_policy"
    t.string "engine_version"
    t.bigint "memory_limit"
    t.boolean "oss_cluster"
    t.string "team"
    t.string "service"
    t.index ["cluster_id", "rl_id"], name: "index_dbs_on_cluster_id_and_rl_id", unique: true
    t.index ["cluster_id"], name: "index_dbs_on_cluster_id"
  end

  create_table "endpoints", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "rl_id"
    t.string "role"
    t.string "ssl"
    t.bigint "db_id"
    t.bigint "node_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["db_id", "rl_id"], name: "index_endpoints_on_db_id_and_rl_id", unique: true
    t.index ["db_id"], name: "index_endpoints_on_db_id"
    t.index ["node_id"], name: "index_endpoints_on_node_id"
  end

  create_table "nodes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "rl_id"
    t.string "role"
    t.string "address"
    t.string "hostname"
    t.integer "num_shards"
    t.integer "num_shards_max"
    t.integer "cores"
    t.string "version"
    t.string "rack"
    t.string "status"
    t.bigint "available_ram"
    t.bigint "available_ram_max"
    t.bigint "ram"
    t.bigint "ram_max"
    t.bigint "cluster_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cluster_id", "rl_id"], name: "index_nodes_on_cluster_id_and_rl_id", unique: true
    t.index ["cluster_id"], name: "index_nodes_on_cluster_id"
  end

  create_table "shards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "rl_id"
    t.string "role"
    t.string "slots"
    t.bigint "used_memory"
    t.string "status"
    t.bigint "db_id"
    t.bigint "node_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["db_id", "rl_id"], name: "index_shards_on_db_id_and_rl_id", unique: true
    t.index ["db_id"], name: "index_shards_on_db_id"
    t.index ["node_id"], name: "index_shards_on_node_id"
  end

  add_foreign_key "dbs", "clusters"
  add_foreign_key "endpoints", "dbs"
  add_foreign_key "endpoints", "nodes"
  add_foreign_key "nodes", "clusters"
  add_foreign_key "shards", "dbs"
  add_foreign_key "shards", "nodes"
end
