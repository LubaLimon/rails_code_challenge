class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.references :user, index: true, null: false
      t.string :address1
      t.string :address2
      t.string :city
      t.string :zipcode
      t.string :state

      t.timestamps
    end
  end
end
