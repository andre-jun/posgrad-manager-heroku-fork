class Report < ApplicationRecord
  has_many :report_infos, dependent: :destroy
  has_many :report_fields, dependent: :destroy

  accepts_nested_attributes_for :report_infos
  accepts_nested_attributes_for :report_fields
end
