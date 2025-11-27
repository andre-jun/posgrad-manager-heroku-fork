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

  validates :name, length: { minimum: 2, maximum: 800 }

  def full_name
    user.full_name
  end

  def calculate_progress
    if user.status == 'Graduado'
      100
    elsif semester > 0
      if program_level == 'Doutorado'
        100 * semester / 8
      else
        100 * semester / 4
      end
    else
      0
    end
  end
end
