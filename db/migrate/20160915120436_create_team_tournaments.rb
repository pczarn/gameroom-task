class CreateTeamTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :team_tournaments do |t|
      t.references :team, foreign_key: true, null: false
      t.references :tournament, foreign_key: true, null: false
      t.integer :size_limit

      t.timestamps
    end
    add_index :team_tournaments, [:team_id, :tournament_id], unique: true
  end
end
