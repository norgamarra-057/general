class AddEngineVersionToDb < ActiveRecord::Migration[5.1]
  def change
    add_column :dbs, :engine_version, :string
  end
end
