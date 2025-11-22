class ReAddReportFieldAnswers < ActiveRecord::Migration[8.1]
  def change
    drop_table :report_field_answers

    create_table :report_field_answers do |t|
      t.belongs_to :report_info, null: false, foreign_key: true
      t.belongs_to :report_fields, null: false, foreign_key: true
      t.string :answer
      t.timestamps
    end
  end
end
