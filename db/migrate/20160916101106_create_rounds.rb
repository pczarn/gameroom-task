class CreateRounds < ActiveRecord::Migration[5.0]
  def change
    create_table :rounds do |t|
      t.references :tournament, foreign_key: true, null: false
      t.integer :number, null: false

      t.timestamps
    end

    add_reference :matches, :round, foreign_key: true
    change_column_null :matches, :played_at, true
    add_index :rounds, [:tournament_id, :number], unique: true
  end
end
