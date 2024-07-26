class CreateEndpoints < ActiveRecord::Migration[5.1]
  def change
    create_table :endpoints do |t|
      t.string :rl_id
      t.string :role
      t.string :ssl
      t.belongs_to :db, foreign_key: true
      t.belongs_to :node, foreign_key: true

      t.timestamps
    end
  end
end
