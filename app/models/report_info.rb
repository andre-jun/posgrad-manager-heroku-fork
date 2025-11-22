class ReportInfo < ApplicationRecord
  belongs_to :student
  belongs_to :report
  has_many :report_field_answers
end
