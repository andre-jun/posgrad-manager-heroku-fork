class RemoveOwnerAndRenameCoordinatorComments < ActiveRecord::Migration[8.1]
  def change
    remove_column :report_infos, :owner, :string
    rename_column :report_infos, :coordinator_comments, :administrator_comments
  end
end
