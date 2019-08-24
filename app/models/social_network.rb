class SocialNetwork < ApplicationRecord
  belongs_to :contact, dependent: :destroy
  validates :type,
            presence: { message: 'Debe indicar el tipo de red social' },
            inclusion: { in: %w[Facebook Whatsapp Twitter Instagram LinkedIn Pinterest Reddit Youtube] }
  validates :url,
            format: { with: URI::regexp, message: 'Formato de URL invalida' },
            if: :url
end