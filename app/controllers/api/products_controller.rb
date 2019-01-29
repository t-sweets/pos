# frozen_string_literal: true

class Api::ProductsController < ApplicationController
  def index
    @products = Product.active_all
    render json: @products
  end

  def update
    @product = Product.find(params[:id])
    if @product&.update(update_params)
      render json: { success: true, product: @product }, status: :ok
    else
      render json: { success: false, errors: [@purchase.errors] }, status: :unprocessable_entity
    end
  end

  private

  def update_params
    params.require(:product).permit(:name, :price, :stock, :display, :cost)
  end
end
