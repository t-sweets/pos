# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_admin!,  except: [:new, :create]
  include DeviseTokenAuth::Concerns::SetUserByToken
end
