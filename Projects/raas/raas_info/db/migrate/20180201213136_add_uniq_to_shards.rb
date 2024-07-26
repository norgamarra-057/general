class AddUniqToShards < ActiveRecord::Migration[5.1]
  def change
    add_index :shards, [:db_id, :rl_id], unique: true
  end
end
