class Api::PurchasesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @purchase = Purchase.all
    render json: @purchases
  end

  def create
    @purchase = Purchase.new(payment_uuid: params[:payment_uuid], payment_method_id: params[:payment_method])
    params["products"].map do |param|
      @purchase.purchase_items.new(product_id: param[:product_id], quantity: param[:quantity], price: param[:price])
    end

    if @purchase.save
      @purchase.purchase_items.map do |item|
        item.allocate_stock
      end

      render json: @purchase, status: :created
    else
      render json: { errors: @purchase.errors }, status: :unprocessable_entity
    end
  end

  def check
    changed = false
    params["products"].map do |product|
      if Product.find(product[:product_id]).price != product[:price]
        changed = true
      end
    end

    if changed
      render json: { errors: "changed price" }, status: 400
    else
      render json: params["products"], status: :ok
    end
  end
end
