class ContactInfo < ApplicationRecord
  belongs_to :user
  validates :contact_info_id, presence: true
  validates :contact_info_id, presence: true
  validates :phone_number, numerically: true, length: { minimum: 5, maximum: 15 }
end
