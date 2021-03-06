class AddAuthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email, :string, null: false
    add_column :users, :password_hashed, :string, null: false
    add_column :users, :role, :integer, null: false, default: 0
    add_index :users, :email, unique: true
  end
end
