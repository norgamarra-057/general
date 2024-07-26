class AddEvictionPolicyToDb < ActiveRecord::Migration[5.1]
  def change
    add_column :dbs, :eviction_policy, :string
  end
end
