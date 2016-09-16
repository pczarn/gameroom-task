class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.datetime :played_at
      t.references :game, foreign_key: true, null: false
      t.references :team_one, references: :team, null: false
      t.references :team_two, references: :team, null: false
      t.integer :team_one_score
      t.integer :team_two_score

      t.timestamps
    end
  end
end
