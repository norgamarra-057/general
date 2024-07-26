class CreateClusters < ActiveRecord::Migration[5.1]
  def change
    create_table :clusters do |t|
      t.string :name

      t.timestamps
    end
    add_index :clusters, :name, unique: true
  end
end
