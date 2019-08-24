class UserProfile < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_one_attached :photo_url, dependent: :destroy
  validates :name,
            presence: { message: 'Debe establecer un nombre para crear su perfil' }
end