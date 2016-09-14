class AddAuthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email, :string
    add_column :users, :password_hashed, :string
    add_index :users, :email, unique: true
  end
end
