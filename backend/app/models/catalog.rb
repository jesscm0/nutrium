class Catalog < ApplicationRecord
  include PgSearch::Model 
  
  belongs_to :nutritionist
  belongs_to :service
  belongs_to :district
  has_many :appointments

  # validations
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }

  pg_search_scope :search_by_text,
    associated_against: {
      nutritionist: [:first_name, :last_name],
      service: [:description]
    },
    using: {
      tsearch: { 
        prefix: true,      # Permite encontrar "Nutrição" escrevendo apenas "nutri"
        any_word: true     # Se escrever "nutricao clinica", ele procura as duas palavras e encontra "nutrição Clinica" mas também "nutrição desportiva", etc
      }
    },
    ignoring: :accents # resolve o problema de "nutricao" vs "nutrição"

  def location
    district&.name
  end

  def name
    service&.description
  end
end
