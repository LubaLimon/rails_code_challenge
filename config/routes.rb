Rails.application.routes.draw do
  root 'admin#index'

  resources :orders, only: [:index, :show, :update], param: :number
 
  resources :reports, only: :index do
    collection do
      get :coupon_users
      get :sales_by_product
    end
  end
end
