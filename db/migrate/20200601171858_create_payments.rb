class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.references :order, index: true, null: false
      t.decimal :amount
      t.string :state
      t.datetime :completed_at
      t.datetime :refunded_at
      t.string :payment_type

      t.timestamps
    end
  end
end
