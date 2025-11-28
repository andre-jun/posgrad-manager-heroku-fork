class Administrator < ApplicationRecord
  belongs_to :user

  has_one :contact_info, through: :user
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :contact_info
end
