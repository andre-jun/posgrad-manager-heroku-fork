class ChangeFirstLoginDefaultInUsers < ActiveRecord::Migration[8.1]
  def change
    change_column_default :users, :first_login, from: true, to: false
  end
end
