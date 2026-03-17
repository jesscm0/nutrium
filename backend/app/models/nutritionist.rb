class Nutritionist < ApplicationRecord
    has_many :catalogs
    has_many :appointments, through: :catalogs

    validates :first_name, :last_name, presence: true, length: { maximum: 30 }
    validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :professional_id, presence: true, uniqueness: true
end
