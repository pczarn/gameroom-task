class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments do |t|
      t.string :title, null: false
      t.string :description
      t.references :game, foreign_key: true, null: false
      t.references :owner, foreign_key: { to_table: :users }, null: false
      t.integer :status, null: false, default: 0
      t.integer :number_of_teams, null: false
      t.integer :number_of_members_per_team
      t.datetime :started_at, null: false
      t.string :image

      t.timestamps
    end
    add_index :tournaments, :title, unique: true
  end
end
