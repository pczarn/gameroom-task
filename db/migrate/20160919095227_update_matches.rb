class UpdateMatches < ActiveRecord::Migration[5.0]
  def change
    add_reference :matches, :round, foreign_key: true
    change_column_null :matches, :played_at, true
  end
end
