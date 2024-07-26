class CreateNodes < ActiveRecord::Migration[5.1]
  def change
    create_table :nodes do |t|
      t.integer :rl_id
      t.string :role
      t.string :address
      t.string :hostname
      t.integer :num_shards
      t.integer :num_shards_max
      t.integer :cores
      t.string :version
      t.string :rack
      t.string :status
      t.bigint :available_ram
      t.bigint :available_ram_max
      t.bigint :ram
      t.bigint :ram_max
      t.belongs_to :cluster, foreign_key: true

      t.timestamps
    end
  end
end
