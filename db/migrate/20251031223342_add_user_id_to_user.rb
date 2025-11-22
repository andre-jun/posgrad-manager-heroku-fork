class AddUserIdToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :login_id, :string, null: false
    rename_column :users, :sing_in_count, :sign_in_count
    add_index :users, :login_id
  end
end
