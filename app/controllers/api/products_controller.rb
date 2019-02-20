# frozen_string_literal: true

class Api::ProductsController < ApplicationController
  before_action :authenticate_admin_or_arriver, only: [:create]
  before_action :authenticate_admin_or_inventoryer, only: %i[update delete]
  before_action :authenticate_admin_or_arriver, only: %i[add_stock increase_prie]
  def index
    @products = Product.all
    render json: @products
  end

  def create
    @product = Product.new(create_params)
    if @product.save
      image_from_base64(params[:image]) if params[:image]
      log_audit(@product, __method__)
      render json: { success: true, product: @product }, status: :created
    else
      render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product&.update(update_params)
      log_audit(@product, __method__)
      render json: { success: true, product: @product }, status: :ok
    else
      render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      File.delete("public/product_images/#{@product.image_path}")
      log_audit(@product, __method__)
      render json: { success: true, product: @product }, status: :ok
    else
      render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
    end
  end

  def add_stock
    if params[:additional_quantity].negative?
      render json: { success: false, errors: ['you cannot reduce stock with your authority.'] }, status: :forbidden
    else
      @product = Product.find(params[:id])
      if @product&.add_stock(add_stock_params)
        log_audit(@product, __method__)
        render json: { success: true, product: @product }, status: :ok
      else
        render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
      end
    end
  end

  def increase_price
    @product = Product.find(params[:id])
    if params[:additional_quantity].negative?
      render json: { success: false, errors: ['you can only raise prices with your authority.'] }, status: :forbidden
    else
      @product = Product.find(params[:id])
      if @product&.increase_price(add_stock_params)
        log_audit(@product, __method__)
        render json: { success: true, product: @product }, status: :ok
      else
        render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
      end
    end
  end

  private

  def create_params
    params.require(:product).permit(:name, :price, :stock, :display, :cost, :image_path, :notification, :notification_stock)
  end

  def update_params
    params.require(:product).permit(:name, :price, :stock, :display, :cost, :image_path, :notification, :notification_stock)
  end

  def add_stock_params
    params.permit(:additional_quantity)
  end

  def increase_price_params
    params.permit(:additional_quantity)
  end

  def image_from_base64(b64)
    bin = Base64.decode64(b64)
    file = Tempfile.new('img')
    file.binmode
    file << bin
    file.rewind
    File.binwrite("public/product_images/#{@product.image_path}", file.read) # TODO: temporary storage
  end

  def log_audit(model, operation)
    AuditLog.create(model: 'product', model_id: model.id, operation: operation, operator: current_user.id)
  end
end
