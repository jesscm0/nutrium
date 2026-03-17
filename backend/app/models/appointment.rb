class Appointment < ApplicationRecord

  belongs_to :guest  #Guest:1 - N:appointment
  belongs_to :catalog #Catalog:1 - N:appointment

  has_one :nutritionist, through: :catalog
  has_one :service, through: :catalog

  validates :scheduled_at, presence: true

  enum status: {
    pending: 0,
    accepted: 1,
    rejected: 2,
    cancelled: 3
  }
end
