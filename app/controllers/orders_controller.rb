class OrdersController < ApplicationController
  before_action :find_order!, only: :show

  def index
  end

  def show
  end

  private
  def find_order!
    @order = Order.find_by!(number: params[:number])
  end
end
