# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/auth/registrations'
      }
      resources :products, only: %i[index create update destroy]
      resources :purchases, only: %i[index show create]
      resources :payment_methods, only: [:index]
      resources :authorities, only: [:index]
      resources :users, only: %i[index destroy]
      post 'purchases/check' => 'purchases#check'
      post 'products/:id/stock' => 'products#add_stock'
      post 'products/:id/price' => 'products#increase_price'
    end
  end
end
