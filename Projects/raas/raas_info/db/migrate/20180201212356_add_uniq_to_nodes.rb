class AddUniqToNodes < ActiveRecord::Migration[5.1]
  def change
    add_index :nodes, [:cluster_id, :rl_id], unique: true
  end
end
