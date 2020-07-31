Rails.application.routes.draw do
  root 'admin#index'

  resources :orders, only: [:index, :show], param: :number

  resources :reports, only: :index do
  end
end
