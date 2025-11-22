class RenameReportInfo < ActiveRecord::Migration[8.1]
  def change
    rename_table :report_info, :report_infos
  end
end
