class AdminsController < ApplicationController
  def login
    @admin = Admin.find_by(name: params[:name])
    if @admin && @admin.authenticate(params[:password])
      render json: { name: params[:name] }, status: :ok
    else
      render json: { error: "login failed" }, status: 400
    end
  end

  def generate_token
    
  end
end
