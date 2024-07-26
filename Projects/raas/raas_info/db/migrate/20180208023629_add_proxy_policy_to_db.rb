class AddProxyPolicyToDb < ActiveRecord::Migration[5.1]
  def change
    add_column :dbs, :proxy_policy, :string
  end
end
