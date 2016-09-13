class AddImageToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :image, :string
  end
end
