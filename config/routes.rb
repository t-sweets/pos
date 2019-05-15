# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        sessions: 'api/auth/sessions',
        registrations: 'api/auth/registrations'
      }

      get 'purchases/sales' => 'purchases#aggregate'
      get 'purchases/actives' => 'purchases#active_index'
      post 'purchases/check' => 'purchases#check'

      get 'registers/balances' => 'registers#show'
      post 'registers/check' => 'registers#check'

      get 'products/jan/:code' => 'products#find_by_jan'
      get 'products/actives' => 'products#active_index'
      post 'products/:id/stock' => 'products#add_stock'
      post 'products/:id/price' => 'products#increase_price'
      post 'products/:id/arrival' => 'products#arrival'

      resources :products, only: %i[index create update destroy]
      resources :purchases, only: %i[index show create destroy]
      resources :payment_methods, only: [:index]
      resources :authorities, only: [:index]
      resources :users, only: %i[index update destroy]
      resources :audit_logs, only: [:index]
      resources :charges, only: [:create]
      resources :withdraws, only: [:create]
      resources :deposits, only: [:create]
    end
  end
end
