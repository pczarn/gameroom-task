class AddRoleToUserTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :user_teams, :role, :integer, default: 0
  end
end
