class Student < ApplicationRecord
  belongs_to :user
  has_one :professor_mentors_student
  has_one :professor, through: :professor_mentors_student
  has_one :contact_info, through: :user
  has_many :publications, dependent: :destroy
  has_many :report_infos
  has_many :report_field_answers, through: :report_info

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :contact_info
  # attr_accessible :user_attributes, :contact_info_attributes

  def calculate_progress
    if credits_needed > 0
      return (100* credits/credits_needed)
    else
      return 0
    end
  end
end
