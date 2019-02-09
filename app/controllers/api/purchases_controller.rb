# frozen_string_literal: true

class Api::PurchasesController < ApplicationController
  before_action :authenticate_admin

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
    @purchase = Purchase.new(payment_uuid: params[:payment_uuid], payment_method_id: params[:payment_method])
    params['products'].map do |product|
      @purchase.purchase_items.new(product_id: product[:product_id], quantity: product[:quantity], price: product[:price])
    end

    if @purchase.save
      @purchase.purchase_items.map(&:allocate_stock)
      post_slack
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
      render json: { success: false, errors: ['changed price.'] }, status: 400
    else
      render json: { success: true, products: params['products'] }, status: :ok
    end
  end

  private

  def post_slack
    text = <<-EOS
    new purchase :tada:
    * uuid: #{@purchase.payment_uuid}
    * items: #{@purchase.purchase_items.map { |i| i.product.name + '(¥' + i.product.price.to_s + ')' }}
    * method: #{@purchase.payment_method.name}
    * time: #{@purchase.created_at.in_time_zone('Tokyo')}
    EOS
    Slack.chat_postMessage(text: text, username: 'pos', channel: '#random')
  end
end
