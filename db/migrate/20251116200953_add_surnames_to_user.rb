class AddSurnamesToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :surname, :string
  end
end
