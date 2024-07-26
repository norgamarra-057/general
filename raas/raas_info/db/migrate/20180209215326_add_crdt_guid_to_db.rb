class AddCrdtGuidToDb < ActiveRecord::Migration[5.1]
  def change
    add_column :dbs, :crdt_guid, :string
  end
end
