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

  scope :arrived, -> { where(state: 'arrived') }
  scope :by_coupon, ->(coupon_id) do
    joins(:order_items)
      .where(order_items: {source_type: "Coupon", source_id: coupon_id })
      .group(:id)
  end

  scope :arrived_between, ->(start_date, end_date) { where(arrived_at: start_date..end_date)}

  def to_param
    number
  end

  def cancel
    order_items.update_all(state: 'returned')
    payments.update_all(state: 'refunded')
    self.update(state: CANCELED)
  end
end
