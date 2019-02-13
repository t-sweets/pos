# frozen_string_literal: true

class Api::AuthoritiesController < ApplicationController
  before_action :authenticate_admin_or_pos, only: [:index]

  def index
    @authorities = Authority.all
    render json: @authorities
  end
end
