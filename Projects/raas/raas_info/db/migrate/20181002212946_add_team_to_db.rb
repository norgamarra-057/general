class AddTeamToDb < ActiveRecord::Migration[5.1]
  def change
    add_column :dbs, :team, :string
  end
end
