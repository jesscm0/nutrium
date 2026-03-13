class Catalog < ApplicationRecord

  belongs_to :nutritionist
  belongs_to :service
  belongs_to :district
  
  has_many :appointments
end
