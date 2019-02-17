# frozen_string_literal: true

class Api::PurchasesController < ApplicationController
  before_action :authenticate_admin_or_pos, only: %i[index show create check]
  before_action :authenticate_admin_or_inventoryer, only: [:checkout]

  def index
    @purchases = Purchase.all
    render json: @purchases
  end

  def show
    @purchase = Purchase.find(params[:id])

    respond_to do |f|
      f.json { render json: @purchase.to_json(include: %i[purchase_items products]) }
    end
  end

  def create
    @purchase = Purchase.new(create_params)
    params['products']&.map do |product|
      @purchase.purchase_items.new(create_purchase_item_params(product))
    end

    if @purchase.save
      @purchase.purchase_items.map(&:allocate_stock)
      render json: { success: true, purchase: @purchase }, status: :created
    else
      render json: { success: false, errors: [@purchase.errors] }, status: :unprocessable_entity
    end
  end

  def check
    changed = false
    params['products'].map do |product|
      changed = true if Product.find(product[:product_id]).price != product[:price]
    end

    if changed
      render json: { success: false, errors: ['changed price.'] }, status: :bad_request
    else
      render json: { success: true, products: params['products'] }, status: :ok
    end
  end

  def checkout
    # TODO: implements
  end

  private

  def create_params
    params.require(:purchase).permit(:payment_uuid, :payment_method_id)
  end

  def create_purchase_item_params(params)
    params.permit(:product_id, :quantity, :price)
  end
end
