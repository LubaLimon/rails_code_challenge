class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :number, index: true, null: false, unique: true
      t.string :state
      t.decimal :total
      t.datetime :building_at
      t.datetime :canceled_at
      t.datetime :arrived_at
      t.references :user, index: true, null: false
      t.references :address

      t.timestamps
    end
  end
end
