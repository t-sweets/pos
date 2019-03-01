# frozen_string_literal: true

class Api::TokensController < ApplicationController
  before_action :authenticate_admin_or_pos, only: [:create]
  before_action :set_token

  def create
    if @token
      @token.update(update_params)
    else
      @token = Token.new(create_params)
    end
    render json: @token
  end

  private

  def create_params
    params.permit(:token, :payment_method_id)
  end

  def update_params
    params.permit(:token)
  end

  def set_token
    @token = Token.find_by(payment_method_id: params[:payment_method_id])
  end
end
