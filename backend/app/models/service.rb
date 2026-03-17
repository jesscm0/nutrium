class Service < ApplicationRecord
  
    has_many :catalogs
    has_many :appointments, through: :catalogs

    enum :service_type, { initial: 'initial', sequence: 'sequence' }

    validates :code, :service_type, :description, presence: true
    validates :code, :service_type, length: { maximum: 30 }
    validates :description, length: { maximum: 100 }

    before_validation { self.code = code.downcase.strip if code.present? }

    validates :code, uniqueness: { scope: :service_type, 
                                 message: "Code and service type must be unique" }
end
