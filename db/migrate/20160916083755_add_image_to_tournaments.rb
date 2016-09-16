class AddImageToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :image, :string
  end
end
