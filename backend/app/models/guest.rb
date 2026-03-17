class Guest < ApplicationRecord

  before_save { self.email = email.downcase if email.present? }

  validates :first_name, :last_name, :email, presence: true, length: { maximum: 30 }
  
  validates :email, 
            presence: true,
            length: { maximum: 100 },
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP}
end