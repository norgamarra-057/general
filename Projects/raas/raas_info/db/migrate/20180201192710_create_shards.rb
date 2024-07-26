class CreateShards < ActiveRecord::Migration[5.1]
  def change
    create_table :shards do |t|
      t.integer :rl_id
      t.string :role
      t.string :slots
      t.bigint :used_memory
      t.string :status
      t.belongs_to :db, foreign_key: true
      t.belongs_to :node, foreign_key: true

      t.timestamps
    end
  end
end
