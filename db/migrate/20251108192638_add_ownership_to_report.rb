class AddOwnershipToReport < ActiveRecord::Migration[8.1]
  def change
    add_column :reports, :owner, :string, default: "Student"
  end
end
