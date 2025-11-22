class AddColumnsToRoles < ActiveRecord::Migration[8.1]
  def change
    add_column :students, :role, :string
    add_column :students, :email, :string
    add_column :students, :lattes_link, :string
    add_column :students, :lattes_last_update, :date
    add_column :students, :pretended_career, :string
    add_column :students, :join_date, :date
  end
end
