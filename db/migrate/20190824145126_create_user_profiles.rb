class CreateUserProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :user_profiles do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.string :address
      t.string :phone
    end
  end
end
