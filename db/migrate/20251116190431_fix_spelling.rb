class FixSpelling < ActiveRecord::Migration[8.1]
  def change
    rename_column :contact_infos, :users_id, :user_id
  end
end
