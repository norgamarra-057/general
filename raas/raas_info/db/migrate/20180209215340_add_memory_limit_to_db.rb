class AddMemoryLimitToDb < ActiveRecord::Migration[5.1]
  def change
    add_column :dbs, :memory_limit, :bigint
  end
end
