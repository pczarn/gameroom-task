class AddOwnerToMatches < ActiveRecord::Migration[5.0]
  def change
    add_reference :matches, :owner, references: :users, index: true
    add_foreign_key :matches, :users, column: :owner_id
  end
end
