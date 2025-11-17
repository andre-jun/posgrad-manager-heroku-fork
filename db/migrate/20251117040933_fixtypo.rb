class Fixtypo < ActiveRecord::Migration[8.1]
  def change
    rename_column :report_field_answers, :report_fields_id, :report_field_id
  end
end
