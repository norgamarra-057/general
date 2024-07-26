class AddOssClusterToDb < ActiveRecord::Migration[5.1]
  def change
    add_column :dbs, :oss_cluster, :boolean
  end
end
