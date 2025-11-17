class AddReviewToReportInfo < ActiveRecord::Migration[8.1]
  def change
    add_column :report_infos, :review_professor, :string, default: "Pendente"
    add_column :report_infos, :review_administrator, :string, default: "Pendente"
  end
end
