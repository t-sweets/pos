# frozen_string_literal: true

class Api::ProductsController < ApplicationController
  before_action :authenticate_admin_or_inventoryer_or_arriver, only: %i[create add_stock increase_price arrival]
  before_action :authenticate_admin_or_inventoryer, only: %i[update destroy]
  before_action :authenticate_signed_in, only: [:find_by_jan]
  before_action :set_product, only: %i[update destroy add_stock increase_price arrival]

  @@no_image_uuid = 'eba953f6-decf-453b-b6ec-fb2c283fc851'

  def index
    @products = Product.all
    render json: @products.to_json(except: %i[created_at updated_at])
  end

  def active_index
    @products = Product.active_all
    render json: @products.to_json(except: %i[created_at updated_at display])
  end

  def find_by_jan
    @product = Product.find_by(jan: params[:code])
    return render json: @product.to_json(except: %i[created_at updated_at]) if @product

    render json: [], status: :bad_request
  end

  def create
    require 'securerandom'

    @product = Product.new(create_params)

    add_image_for_create

    @product[:jan] = params[:jan] if params[:jan]

    Product.transaction do
      if @product.save!
        log_audit(@product, __method__)
        render json: { success: true, product: @product.attributes.except('created_at', 'updated_at') }, status: :created
      else
        render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
      end
    end
  rescue StandardError => e
    render json: { success: false, errors: [e] }, status: :unprocessable_entity
  end

  def update
    @product[:jan] = params[:jan] if params[:jan]

    add_image_for_update

    Product.transaction do
      if @product&.update!(update_params)
        log_audit(@product, __method__)
        render json: { success: true, product: @product.attributes.except('created_at', 'updated_at') }, status: :ok
      else
        render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
      end
    end
  rescue StandardError => e
    render json: { success: false, errors: [e] }, status: :unprocessable_entity
  end

  def destroy
    Product.transaction do
      if @product.destroy!
        File.delete!("public#{@product.image_path}") if @product[:image_uuid]
        log_audit(@product, __method__)
        head :no_content
      else
        render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
      end
    end
  rescue StandardError => e
    render json: { success: false, errors: [e] }, status: :unprocessable_entity
  end

  def add_stock
    return render json: { success: false, errors: ['you cannot reduce stock with your authority.'] }, status: :forbidden if params[:additional_quantity].negative?

    Product.transaction do
      if @product&.add_stock!(add_stock_params)
        log_audit(@product, __method__)
        render json: { success: true, product: @product.attributes.except('created_at', 'updated_at') }, status: :ok
      else
        render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
      end
    end
  rescue StandardError => e
    render json: { success: false, errors: [e] }, status: :unprocessable_entity
  end

  def increase_price
    return render json: { success: false, errors: ['you can only raise prices with your authority.'] }, status: :forbidden if params[:additional_quantity].negative?

    Product.transaction do
      if @product&.increase_price!(add_stock_params)
        log_audit(@product, __method__)
        render json: { success: true, product: @product.attributes.except('created_at', 'updated_at') }, status: :ok
      else
        render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
      end
    end
  rescue StandardError => e
    render json: { success: false, errors: [e] }, status: :unprocessable_entity
  end

  def arrival
    return render json: { success: false, errors: ['you cannot reduce stock with your authority.'] }, status: :forbidden if params[:price_additional_quantity].negative? || params[:stock_additional_quantity].negative?

    Product.transaction do
      if @product&.arrival!(arrival_params)
        log_audit(@product, __method__)
        render json: { success: true, product: @product.attributes.except('created_at', 'updated_at') }, status: :ok
      else
        render json: { success: false, errors: [@product.errors] }, status: :unprocessable_entity
      end
    end
  rescue StandardError => e
    render json: { success: false, errors: [e] }, status: :unprocessable_entity
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

  def arrival_params
    params.permit(:price_additional_quantity, :stock_additional_quantity, :cost)
  end

  def add_image_for_create
    if uri?(params[:image])
      @product[:image_path] = params[:image]
    else
      @product[:image_uuid] = params[:image] ? SecureRandom.uuid : @@no_image_uuid
      @product[:image_path] = '/product_images/' + @product.image_uuid + '.png'
      image_from_base64(params[:image]) if params[:image]
    end
  end

  def add_image_for_update
    return unless params[:image]

    File.delete("public#{@product.image_path}") if @product.image_uuid && @product.image_uuid != @@no_image_uuid

    if uri?(params[:image])
      @product[:image_uuid] = nil
      @product[:image_path] = params[:image]
    else
      @product[:image_uuid] = SecureRandom.uuid
      @product[:image_path] = '/product_images/' + @product[:image_uuid] + '.png'
      image_from_base64(params[:image])
    end
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
    AuditLog.create!(model: 'product', model_id: model.id, operation: operation, operator: current_user.id)
  end

  def uri?(string)
    string.include?('http')
  end
end
