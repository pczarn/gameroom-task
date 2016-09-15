class CreateMatchTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :match_tournaments do |t|
      t.references :match, foreign_key: true, null: false
      t.references :tournament, foreign_key: true, null: false

      t.timestamps
    end
    add_index :match_tournaments, [:match_id, :tournament_id], unique: true
  end
end
