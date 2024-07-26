class AddUniqToEndpoints < ActiveRecord::Migration[5.1]
  def change
    add_index :endpoints, [:db_id, :rl_id], unique: true
  end
end
