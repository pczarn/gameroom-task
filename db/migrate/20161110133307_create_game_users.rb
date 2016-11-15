class CreateGameUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :game_users do |t|
      t.references :game, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.float :mean, null: false
      t.float :deviation, null: false

      t.timestamps
    end

    add_index :game_users, [:user_id, :game_id], unique: true
  end
end
