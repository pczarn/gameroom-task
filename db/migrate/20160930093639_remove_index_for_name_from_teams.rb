class RemoveIndexForNameFromTeams < ActiveRecord::Migration[5.0]
  def change
    remove_index :teams, :name
  end
end
