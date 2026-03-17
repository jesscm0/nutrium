class District < ApplicationRecord
    has_many :catalogs

    validates :name, presence: true, length: { maximum: 50 }
    validates :code, presence: true, uniqueness: true, length: { maximum: 50 }
end
