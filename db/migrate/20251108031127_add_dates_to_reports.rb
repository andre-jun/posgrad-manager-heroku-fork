class AddDatesToReports < ActiveRecord::Migration[8.1]
  def change
    add_column :reports, :semester, :integer
    add_column :reports, :year, :integer
    add_column :reports, :date_sent, :date
    remove_column :reports, :name
  end
end
