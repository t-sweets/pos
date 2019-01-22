class PurchasesController < ApplicationController

  def index
    @purchase = Purchase.all
    render json: @purchases
  end

  def create
    @purchase = Purchase.new(payment_uuid: param["payment_uuid"])
    params["products"].map do |param|
      @purchase.purchase_item.new(product_id: param[:product_id], quantity: param[:quantity])
    end

    if @purchase.save
      render json: @purchase, status: :created
    else
      render json: { errors: @purchase.errors }, status: :unprocessable_entity
    end
  end
end
