# frozen_string_literal: true

class Api::PurchasesController < ApplicationController
  before_action :authenticate_admin_or_pos, only: %i[index show create check destroy]
  before_action :authenticate_admin_or_inventoryer, only: [:checkout]
  before_action :authenticate_admin_or_pos_or_arriver, only: [:aggregate]
  before_action :set_purchase, only: %i[show destroy]

  def index
    @purchases = Purchase.all
    render json: @purchases.to_json(methods: [:sales], include: { purchase_items: { only: %i[id product_id quantity price] } })
  end

  def show
    # render json: @purchase.to_json(include: %i[purchase_items products])
    render json: @purchase.to_json(include: { purchase_items: {include: :product}} )
  end

  def create
    @purchase = Purchase.new(create_params)
    params['products']&.map do |product|
      @purchase.purchase_items.new(create_purchase_item_params(product))
    end

    if @purchase.save
      @purchase.purchase_items.map(&:allocate_stock)
      log_audit(@purchase, __method__)
      render json: { success: true, purchase: @purchase }, status: :created
    else
      render json: { success: false, errors: [@purchase.errors] }, status: :unprocessable_entity
    end
  end

  def check
    changed = false
    params['products'].each do |product|
      changed = true if Product.find(product[:product_id]).price != product[:price]
    end

    if changed
      render json: { success: false, errors: ['changed price.'] }, status: :ok
    else
      render json: { success: true, products: params['products'] }, status: :ok
    end
  end

  def checkout
    # TODO: implements
  end

  def aggregate
    if params[:year] && params[:month]
      from = DateTime.new(params[:year].to_i, params[:month].to_i, 1)
      to = DateTime.new(params[:year].to_i, params[:month].to_i, -1)
      @purchases = Purchase.where('created_at BETWEEN ? AND ?', from, to)
      render json: @purchases.to_json(methods: [:sales], include: { purchase_items: { only: %i[id product_id quantity price] } })
    elsif params[:product_id]
      @purchase_items = PurchaseItem.where('product_id = ?', params[:product_id])
      render json: @purchase_items.to_json(only: %i[id product_id quantity price], include: { purchase: { methods: [:sales] } })
    end
  end

  def destroy
    if @purchase&.cancel
      log_audit(@purchase, __method__)
      render json: { success: true, purchase: @purchase }, status: :ok
    else
      render json: { success: false, errors: [@purchase.errors] }, status: :unprocessable_entity
    end
  end

  private

  def set_purchase
    @purchase = Purchase.find(params[:id])
  end

  def create_params
    params.require(:purchase).permit(:payment_uuid, :payment_method_id)
  end

  def create_purchase_item_params(params)
    params.permit(:product_id, :quantity, :price)
  end

  def log_audit(model, operation)
    AuditLog.create(model: 'purchase', model_id: model.id, operation: operation, operator: current_user.id)
  end
end
