class CreateDbs < ActiveRecord::Migration[5.1]
  def change
    create_table :dbs do |t|
      t.integer :rl_id
      t.string :name
      t.string :engine
      t.string :status
      t.integer :num_shards
      t.string :placement
      t.string :replication
      t.string :persistence
      t.string :endpoint_host
      t.integer :endpoint_port
      t.belongs_to :cluster, foreign_key: true

      t.timestamps
    end
  end
end
