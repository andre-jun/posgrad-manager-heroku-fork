class ChangeEmailDefaultColumn < ActiveRecord::Migration[8.1]
  def change
    change_column :users, :email, :string, default: ""
  end
end
