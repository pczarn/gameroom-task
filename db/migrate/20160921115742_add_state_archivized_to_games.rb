class AddStateArchivizedToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :state_archivized, :bool, default: false, null: false
  end
end
