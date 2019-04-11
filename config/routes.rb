# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        sessions: 'api/auth/sessions',
        registrations: 'api/auth/registrations'
      }
      post 'purchases/check' => 'purchases#check'
      get 'purchases/sales' => 'purchases#aggregate'
      get 'registers/balances' => 'registers#show'
      post 'registers/balances' => 'registers#init'
      put 'registers/check' => 'registers#check'
      post 'products/:id/stock' => 'products#add_stock'
      post 'products/:id/price' => 'products#increase_price'
      get 'products/jan/:code' => 'products#find_by_jan'
      resources :products, only: %i[index create update destroy]
      resources :purchases, only: %i[index show create destroy]
      resources :payment_methods, only: [:index]
      resources :authorities, only: [:index]
      resources :users, only: %i[index update destroy]
      resources :audit_logs, only: [:index]
      resources :charges, only: [:create]
      resources :withdraws, only: [:create]
    end
  end
end
