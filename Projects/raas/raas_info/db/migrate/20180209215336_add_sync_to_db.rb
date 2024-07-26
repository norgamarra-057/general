class AddSyncToDb < ActiveRecord::Migration[5.1]
  def change
    add_column :dbs, :sync, :string
  end
end
