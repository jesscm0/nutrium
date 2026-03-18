class Appointment < ApplicationRecord

  belongs_to :guest  #Guest:1 - N:appointment
  belongs_to :catalog #Catalog:1 - N:appointment

  has_one :nutritionist, through: :catalog
  has_one :service, through: :catalog

  validates :scheduled_at, presence: true

  enum :status, { pending: 0, accepted: 1, rejected: 2, cancelled: 3 }

  validate :scheduled_at_cannot_be_in_the_past
  def scheduled_at_cannot_be_in_the_past
    if scheduled_at.present? && scheduled_at < Time.current
      errors.add(:scheduled_at, "cannot be in the past")
    end
  end

end
