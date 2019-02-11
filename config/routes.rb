# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/auth/registrations'
      }
      resources :products, only: %i[index create update]
      resources :purchases, only: %i[index show create]
      resources :payment_methods, only: [:index]
      resources :authorities, only: [:index]
      post 'purchases/check' => 'purchases#check'
    end
  end
end
