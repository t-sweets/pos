Rails.application.routes.draw do
  resources :products, only: [:index]
  resources :purchases, only: [:index, :create]
  resources :payment_methods, only: [:index]
end
