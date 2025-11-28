class ReportInfo < ApplicationRecord
  belongs_to :student
  belongs_to :report
  belongs_to :reviewer, class_name: 'Professor', foreign_key: :reviewer_id, optional: true
  has_many :report_field_answers, dependent: :destroy
  accepts_nested_attributes_for :report_field_answers
  # Owner pode ser: "Student", "Professor" e "Administrator"
  # Status pode ser (e de quem é a responsa agora): "Draft"(student), "Sent"(professor), "Review"(admin), "Archived"(retornou ao student)
  before_update :set_date_sent_when_submitted

  private

  def set_date_sent_when_submitted
    return unless status_changed? && status == 'Submitted'

    self.date_sent = Time.current
  end
end
