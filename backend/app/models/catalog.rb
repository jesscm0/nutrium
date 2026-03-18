class Catalog < ApplicationRecord
  include PgSearch::Model 
  
  belongs_to :nutritionist
  belongs_to :service
  belongs_to :district
  has_many :appointments

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }

  pg_search_scope :search_by_profile,
    associated_against: {
      nutritionist: [:first_name, :last_name],
      service: [:description]
    },
    using: {
      tsearch: {
        prefix: true,
        any_word: true
      }
    },
    ignoring: :accents

  pg_search_scope :search_by_location,
    associated_against: {
      district: [:name]
    },
    using: {
      tsearch: {
        prefix: true,
        any_word: true
      },
      trigram: {
        threshold: 0.2,
        word_similarity: true
      }
    },
    ignoring: :accents

  def location
    district&.name
  end

  def name
    service&.description
  end
end
