# frozen_string_literal: true

class Api::UsersController < ApplicationController
  before_action :authenticate_admin, only: [:index]

  def index
    @users = User.alive_all
    render json: @users, only: %i[id name email authority_id created_at]
  end

  def destroy
    @user = User.find(params[:id])
    if @user&.update(deleted: true)
      render json: { success: true, user: @user }, status: :ok
    else
      render json: { success: false, errors: [@user.errors] }, status: :unprocessable_entity
    end
  end
end
