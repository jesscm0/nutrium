class Appointment < ApplicationRecord

  belongs_to :guest
  belongs_to :catalog
  #belongs_to :nutritionist
  #belongs_to :service


  enum status: {
    pending: 0,
    accepted: 1,
    rejected: 2
  }
end
