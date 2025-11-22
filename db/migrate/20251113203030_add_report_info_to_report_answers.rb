class AddReportInfoToReportAnswers < ActiveRecord::Migration[8.1]
  def change
    remove_column :report_field_answers, :report_id
  end
end
