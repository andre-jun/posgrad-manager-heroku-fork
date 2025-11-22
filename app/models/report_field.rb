class ReportField < ApplicationRecord
  belongs_to :report
  has_many :report_field_answers, dependent: :destroy
end
