Rails.application.routes.draw do

  scope :api do
    scope :v1 do
      resources :products, only: [:index]
      resources :purchases, only: [:index, :create]
      resources :payment_methods, only: [:index]
      post "purchases/check" => "purchases#check"
      post "login" => "admins#login"
    end
  end
end
