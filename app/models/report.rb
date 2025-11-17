class Report < ApplicationRecord
  has_many :report_infos
  has_many :report_fields  

  accepts_nested_attributes_for :report_infos
  accepts_nested_attributes_for :report_fields
end
