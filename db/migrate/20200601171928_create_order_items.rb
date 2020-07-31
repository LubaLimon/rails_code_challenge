class CreateOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.integer :quantity
      t.decimal :price
      t.string :state
      t.references :order, index: true, null: false
      t.references :source, polymorphic: true

      t.timestamps
    end
  end
end
