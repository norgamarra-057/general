class AddServiceToDb < ActiveRecord::Migration[5.1]
  def change
    add_column :dbs, :service, :string
  end
end
