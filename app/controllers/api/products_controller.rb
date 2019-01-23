class Api::ProductsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @products = Product.all
    render json: @products
  end
end
