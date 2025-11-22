class IdkAnymore < ActiveRecord::Migration[8.1]
  def change
    change_column :users, :login_id, :string, null: true
  end
end
