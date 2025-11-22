class ReportFieldAnswer < ApplicationRecord
  belongs_to :report_info
  belongs_to :report_field
end
