class AddUniqToDbs < ActiveRecord::Migration[5.1]
  def change
    add_index :dbs, [:cluster_id, :rl_id], unique: true
  end
end
