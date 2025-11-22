class SmallFix < ActiveRecord::Migration[8.1]
  def change
    add_reference :report_field_answers, :report_info, index: true
  end
end
