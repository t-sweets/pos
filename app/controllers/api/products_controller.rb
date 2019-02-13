# frozen_string_literal: true

class Api::ProductsController < ApplicationController
  def index
    @products = Product.all
    render json: @products
  end

  def create
    @product = Product.new(create_params)
    if @product.save
      image_from_base64(params[:image]) if params[:image]
      render json: { success: true, product: @product }, status: :ok
    else
      render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product&.update(update_params)
      render json: { success: true, product: @product }, status: :ok
    else
      render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      File.delete("public/product_images/#{@product.image_path}")
      render json: { success: true, product: @product }, status: :ok
    else
      render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.require(:product).permit(:name, :price, :stock, :display, :cost, :image_path, :notification, :notification_stock)
  end

  def update_params
    params.require(:product).permit(:name, :price, :stock, :display, :cost, :image_path, :notification, :notification_stock)
  end

  def image_from_base64(b64)
    bin = Base64.decode64(b64)
    file = Tempfile.new('img')
    file.binmode
    file << bin
    file.rewind
    File.binwrite("public/product_images/#{@product.image_path}", file.read) # TODO: temporary storage
  end
end
