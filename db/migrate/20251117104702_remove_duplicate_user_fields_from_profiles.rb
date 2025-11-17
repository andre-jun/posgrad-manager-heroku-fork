class RemoveDuplicateUserFieldsFromProfiles < ActiveRecord::Migration[8.1]
  def change
    remove_column :students, :name, :string
    remove_column :students, :email, :string
    rename_column :students, :role, :program_level

    remove_column :professors, :name, :string

    remove_column :administrators, :name, :string
    remove_column :administrators, :role, :string
  end
end
