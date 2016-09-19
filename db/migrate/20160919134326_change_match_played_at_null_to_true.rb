class ChangeMatchPlayedAtNullToTrue < ActiveRecord::Migration[5.0]
  def change
    change_column_null :matches, :played_at, true
  end
end
