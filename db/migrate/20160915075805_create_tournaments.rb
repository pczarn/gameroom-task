class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments do |t|
      t.string :title, null: false
      t.references :game, foreign_key: true, null: false
      t.integer :status, null: false, default: 0
      t.integer :number_of_teams, null: false
      t.datetime :started_at, null: false
      t.integer :number_of_members_per_team

      t.timestamps
    end
    add_index :tournaments, :title, unique: true
  end
end
