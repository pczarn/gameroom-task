class CreateUserTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :user_teams do |t|
      t.references :user, foreign_key: true, null: false
      t.references :team, foreign_key: true, null: false

      t.timestamps
    end

    add_index :user_teams, [:user_id, :team_id], unique: true
  end
end
