# frozen_string_literal: true

class Api::AuthoritiesController < ApplicationController
  def index
    @authorities = Authority.all
    render json: @authorities.to_json(only: %i[id name])
  end
end
