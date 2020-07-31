class User < ApplicationRecord

  validates :name,
            presence: true

  validates :email,
            presence: true,
            uniqueness: true

  has_many :orders
  has_many :addresses

  def arrived_coupon_orders(coupon_id)
    orders.arrived.by_coupon(coupon_id)
  end

  def arrived_orders_count(coupon_id)
    arrived_coupon_orders(coupon_id).pluck('count(*)').first || 0
  end

   def arrived_orders_revenue(coupon_id)
    arrived_coupon_orders(coupon_id).pluck('sum(orders.total)').first || 0
  end
end
