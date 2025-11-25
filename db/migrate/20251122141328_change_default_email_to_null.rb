class ChangeDefaultEmailToNull < ActiveRecord::Migration[8.1]
  def change
    change_column_default :users, :email, from: '', to: nil
  end
end
