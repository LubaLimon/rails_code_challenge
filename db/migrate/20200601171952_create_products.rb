class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string  :name
      t.string  :sku, unique: true
      t.decimal :msrp
      t.decimal :cost

      t.timestamps
    end
  end
end
