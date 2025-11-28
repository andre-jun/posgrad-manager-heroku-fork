class RenamePublicationNameToTile < ActiveRecord::Migration[8.1]
  def change
    rename_column :publications, :name, :title
  end
end
