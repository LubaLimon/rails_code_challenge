class OrdersController < ApplicationController
  before_action :find_order!, only: [:show, :update]

  SEARCHABLE_FIELDS = ['orders.number','orders.state', 'users.email'].freeze

  def index
    if params[:query].present?
      @orders ||= Order.joins([:user, :address]).where("#{query_field} LIKE ?", "%#{params[:query]}%").paginate(page: params[:page])
    else
      @orders ||= Order.joins([:user, :address]).paginate(page: params[:page])
    end
  end

  def show
  end

  def update
    @order.cancel
    redirect_to  action: :show
  end

  private
  def find_order!
    @order = Order.find_by!(number: params[:number])
  end

  def query_field
    if SEARCHABLE_FIELDS.include? params[:query_field]
      params[:query_field]
    else
      nil
    end
  end
end
