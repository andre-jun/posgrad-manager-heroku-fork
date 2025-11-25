class ReportInfo < ApplicationRecord
  belongs_to :student
  belongs_to :report
  has_many :report_field_answers

  # Owner pode ser: "Student", "Professor" e "Administrator"
  # Status pode ser (e de quem é a responsa agora): "Draft"(student), "Sent"(professor), "Review"(admin), "Archived"(retornou ao student)
end
