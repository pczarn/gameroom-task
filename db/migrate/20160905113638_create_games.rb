class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.string :name, unique: true

      t.timestamps
    end
  end
end
