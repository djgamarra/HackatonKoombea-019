class User < ApplicationRecord
  has_one :user_profile
  has_many :contacts
  has_secure_password
  has_secure_token :api_key
  validates :email,
            presence: { message: 'Debe establecer un email para crear una cuenta' },
            uniqueness: { case_sensitive: false, message: 'Email ya registrado' },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Formato invalido de email' }
  validates :password,
            presence: { message: 'Debe establecer una contraseña para crear su cuenta' },
            length: { minimum: 8, too_short: 'La contraseña debe contener al menos 8 caracteres' },
            if: :password
  validates :password_confirmation,
            inclusion: { in: -> user { [user.password] }, message: 'Contraseña y validación no corresponden' },
            if: :password_confirmation

  def logout
    self.api_key = nil
    return false unless self.save
    true
  end

  def info
    profile = self.user_profile
    if profile.photo_url.attached?
      info = profile.as_json only: %i[id name address phone], include: { photo_url: {} }
    else
      info = profile.as_json only: %i[id name address phone]
      info[:photo_url] = nil
    end
    info[:email] = self.email
    info[:api_key] = self.api_key
    info
  end

  def self.instance(user_params, profile_params)
    user = User.new user_params
    profile = UserProfile.new profile_params
    return { okay: false, payload: user.error_msgs } unless user.save
    profile.user_id = user.id
    unless profile.save
      user.destroy
      return { okay: false, payload: profile.error_msgs }
    end
    { okay: true, payload: user }
  end

  def self.auth(email, password)
    user = User.find_by_email email
    return false if user.nil?
    return false unless user.authenticate password
    user.regenerate_api_key
    return user
  end
end
