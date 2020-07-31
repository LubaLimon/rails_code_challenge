class ReportsController < ApplicationController
  def index
  end

  def coupon_users
    @coupon = params[:coupon_id] && Coupon.find(params[:coupon_id])
  end

  def sales_by_product
    if params[:commit].present?
      order_ids = Order.arrived_between(params[:start_date], params[:end_date]).pluck(:id)
      @products = Product.by_orders(order_ids).select('name, sum(products.cost) as revenue, count(*) as count')
    end
  end
end
