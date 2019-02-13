# frozen_string_literal: true

class Api::UsersController < ApplicationController
  before_action :authenticate_admin

  def index
    @users = User.all
    render json: @users, only: %i[id name email authority_id created_at]
  end
end
