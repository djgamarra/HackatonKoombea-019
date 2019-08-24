class Contact < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :social_networks
  validates :name,
            presence: { message: 'Debe indicar el nombre del contacto' }
  validates :phone,
            presence: { message: 'Debe indicar el numero de telefono' }
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Formato invalido de email' },
            if: :email

  def self.instance(attrs, social_ns, user)
    nets = social_ns || []
    contact = Contact.new attrs
    contact.user_id = user.id
    return { okay: false, payload: contact.error_msgs } unless contact.save
    nets.each do |sn|
      net = SocialNetwork.new
      net.contact_id = contact.id
      net.type = sn[:type]
      net.url = sn[:url]
      net.number = sn[:number]
      net.save
    end
    { okay: true, payload: contact }
  end

  def self.update(id, attrs)
    contact = Contact.find_by_id id
    return false if contact.nil?
    return false unless contact.update attrs
    contact
  end

  def self.serialize(obj)
    obj.to_json only: %i[id name email address phone],
                include: { social_networks: { only: %i[type url number] } }
  end
end