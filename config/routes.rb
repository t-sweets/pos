Rails.application.routes.draw do
  devise_for :admins

  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for 'Admin', at: 'auth'
      resources :products, only: [:index]
      resources :purchases, only: [:index, :create]
      resources :payment_methods, only: [:index]
      post "purchases/check" => "purchases#check"
    end
  end
end
