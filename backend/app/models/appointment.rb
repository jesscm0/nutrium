class Appointment < ApplicationRecord

  belongs_to :guest
  belongs_to :catalog

  has_one :nutritionist, through: :catalog
  has_one :service, through: :catalog


  enum status: {
    pending: 0,
    accepted: 1,
    rejected: 2
  }
end
