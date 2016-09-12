class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.datetime :played_at, null: false
      t.references :game, foreign_key: true
      t.references :team_one, references: :team
      t.references :team_two, references: :team
      t.integer :team_one_score, null: true
      t.integer :team_two_score, null: true

      t.timestamps
    end
  end
end
