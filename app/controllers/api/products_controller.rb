# frozen_string_literal: true

class Api::ProductsController < ApplicationController
  before_action :authenticate_admin_or_arriver, only: [:create]
  before_action :authenticate_admin_or_inventoryer, only: %i[update delete]
  before_action :authenticate_admin_or_arriver, only: %i[add_stock increase_prie]
  before_action :authenticate_admin_or_pos, only: [:find_by_jan]
  before_action :set_product, only: %i[update destroy add_stock increase_price]

  @@no_image_uuid = 'eba953f6-decf-453b-b6ec-fb2c283fc851'

  def index
    @products = Product.all
    render json: @products
  end

  def find_by_jan
    @product = Product.find_by(jan: params[:code])
    return render json: @product if @product

    render json: [], status: :bad_request
  end

  def create
    require 'securerandom'

    @product = Product.new(create_params)

    if uri?(params[:image])
      @product[:image_path] = params[:image]
    else
      @product[:image_uuid] = params[:image] ? SecureRandom.uuid : @@no_image_uuid
      @product[:image_path] = '/product_images/' + @product.image_uuid + '.png'
      image_from_base64(params[:image]) if params[:image]
    end

    @product[:jan] = params[:jan] if params[:jan]

    if @product.save
      log_audit(@product, __method__)
      render json: { success: true, product: @product }, status: :created
    else
      render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
    end
  end

  def update
    @product[:jan] = params[:jan] if params[:jan]

    if params[:image]
      if uri?(params[:image])
        @product[:image_uuid] = nil
        @product[:image_path] = params[:image]
        File.delete("public#{@product.image_path}") if @product[:image_uuid] && @product.image_uuid != @@no_image_uuid
      elsif @product.image_uuid
        File.delete("public#{@product.image_path}") unless @product.image_uuid == @@no_image_uuid
        image_from_base64(params[:image])
      else
        @product[:image_uuid] = params[:image] ? SecureRandom.uuid : @@no_image_uuid
        @product[:image_path] = '/product_images/' + @product[:image_uuid] + '.png'
        image_from_base64(params[:image])
      end
    end

    if @product&.update(update_params)
      log_audit(@product, __method__)
      render json: { success: true, product: @product }, status: :ok
    else
      render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy && @product[:image_uuid]
      File.delete("public#{@product.image_path}") if @product[:image_uuid]
      log_audit(@product, __method__)
      render json: { success: true, product: @product }, status: :no_content
    else
      render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
    end
  end

  def add_stock
    return render json: { success: false, errors: ['you cannot reduce stock with your authority.'] }, status: :forbidden if params[:additional_quantity].negative?

    if @product&.add_stock(add_stock_params)
      log_audit(@product, __method__)
      render json: { success: true, product: @product }, status: :ok
    else
      render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
    end
  end

  def increase_price
    return render json: { success: false, errors: ['you can only raise prices with your authority.'] }, status: :forbidden if params[:additional_quantity].negative?

    if @product&.increase_price(add_stock_params)
      log_audit(@product, __method__)
      render json: { success: true, product: @product }, status: :ok
    else
      render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def create_params
    params.require(:product).permit(:name, :price, :stock, :display, :cost, :notification, :notification_stock)
  end

  def update_params
    params.require(:product).permit(:name, :price, :stock, :display, :cost, :notification, :notification_stock)
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
    File.binwrite("public/product_images/#{@product.image_uuid}.png", file.read) # TODO: temporary storage
  end

  def log_audit(model, operation)
    AuditLog.create(model: 'product', model_id: model.id, operation: operation, operator: current_user.id)
  end

  def uri?(string)
    string.include?('http')
  end
end
