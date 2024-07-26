class AddVersionToCluster < ActiveRecord::Migration[5.1]
  def change
    add_column :clusters, :version, :string
  end
end
