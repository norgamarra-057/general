class AddResqueWebToDb < ActiveRecord::Migration[5.1]
  def change
    add_column :dbs, :resque_web, :string
  end
end
