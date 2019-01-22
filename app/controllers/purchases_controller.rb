class PurchasesController < ApplicationController

  def index
    @purchase = Purchase.all
    render json: @purchases
  end

  def create
    @purchase = Purchase.new(payment_uuid: params[:payment_uuid], payment_method_id: params[:payment_method])
    params["products"].map do |param|
      @purchase.purchase_item.new(product_id: params[:product_id], quantity: params[:quantity])
    end

    if @purchase.save
      render json: @purchase, status: :created
    else
      render json: { errors: @purchase.errors }, status: :unprocessable_entity
    end
  end
end
