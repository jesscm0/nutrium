class Appointment < ApplicationRecord

  belongs_to :guest
  belongs_to :catalog


  enum status: {
    pending: 0,
    accepted: 1,
    rejected: 2
  }
end
