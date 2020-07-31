class Payment < ApplicationRecord
  COMPLETED = "completed"
  REFUNDED = "refunded"
  STATES = [COMPLETED, REFUNDED].freeze

  CREDIT_CARD = "CreditCard"
  STORE_CREDIT = "StoreCredit"
  PAYMENT_TYPES = [CREDIT_CARD, STORE_CREDIT].freeze

  validates_presence_of :order_id, :state, :payment_type

  validates   :amount,
              presence: true,
              format: {
                with: /\A-?\d+\.?\d{0,2}\z/,
                message: 'only accepts 2 decimal places.'
              }

  belongs_to :order
end
