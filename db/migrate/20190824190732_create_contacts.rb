class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.integer :user_id
      t.string :name, null: false
      t.string :email
      t.string :address
      t.string :phone, null: false
      t.integer :user_id, null: true
    end
  end
end
