class Tax < ApplicationRecord
  validates :name,
            presence: true

  validates :rate,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 1
            },
            format: {
              with: /\A-?\d+\.?\d{0,3}\z/,
              message: 'only accepts 3 decimal places.'
            }

  has_many :order_items,
           as: :source
end
