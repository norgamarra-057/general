class AddMonitoringClusterToCluster < ActiveRecord::Migration[5.1]
  def change
    add_column :clusters, :monitoring_cluster, :string
  end
end
