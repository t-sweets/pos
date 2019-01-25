class Api::ProductsController < ApplicationController

  def index
    @products = Product.active_all
    render json: @products
  end

  def update
    @product = Product.find(params[:id])
    if @product && @product.update(update_params)
      render json: @product
    else
      render json: { errors: @purchase.errors }, status: :unprocessable_entity
    end
  end

  private
  def update_params
    params.require(:product).permit(:name, :price, :stock, :display, :cost)
  end
end
