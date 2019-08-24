class CreateSocialNetworks < ActiveRecord::Migration[5.2]
  def change
    create_table :social_networks do |t|
      t.integer :contact_id
      t.string :type, null: false
      t.string :url
      t.string :number
    end
  end
end
