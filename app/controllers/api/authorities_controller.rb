# frozen_string_literal: true

class Api::AuthoritiesController < ApplicationController
  def index
    @authorities = Authority.all
    render json: @authorities
  end
end
