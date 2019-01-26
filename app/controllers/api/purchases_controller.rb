# frozen_string_literal: true

class Api::PurchasesController < ApplicationController
  def index
    @purchases = Purchase.all
    render json: @purchases
  end
  
  def show
    @purchase = Purchase.find(params[:id])

    respond_to do |f|
      f.json { render json: @purchase.to_json(:include => [:purchase_items, :products])}
    end
  end

  def create
    @purchase = Purchase.new(payment_uuid: params[:payment_uuid], payment_method_id: params[:payment_method])
    params['products'].map do |product|
      @purchase.purchase_items.new(product_id: product[:product_id], quantity: product[:quantity], price: product[:price])
    end

    if @purchase.save
      @purchase.purchase_items.map(&:allocate_stock)
      render json: @purchase, status: :created
    else
      render json: { errors: @purchase.errors }, status: :unprocessable_entity
    end
  end

  def check
    changed = false
    params['products'].map do |product|
      changed = true if Product.find(product[:product_id]).price != product[:price]
    end

    if changed
      render json: { errors: 'changed price' }, status: 400
    else
      render json: params['products'], status: :ok
    end
  end
end
