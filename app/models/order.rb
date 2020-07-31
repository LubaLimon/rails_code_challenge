class Order < ApplicationRecord
  BUILDING = "building"
  ARRIVED = "arrived"
  CANCELED = "canceled"
  STATES = [BUILDING, ARRIVED, CANCELED].freeze

  validates_presence_of :user_id, :state

  validates   :total,
              presence: true,
              format: {
                with: /\A-?\d+\.?\d{0,2}\z/,
                message: 'only accepts 2 decimal places.'
              }

  belongs_to :user
  belongs_to :address

  has_many :order_items
  has_many :payments

  def to_param
    number
  end
end
