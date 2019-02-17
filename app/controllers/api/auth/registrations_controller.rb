# frozen_string_literal: true

module Api
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      before_action :authenticate_admin, only: [:create]
      before_action :authenticate_admin_and_login_user, only: [:update]

      def update
        @user = User.find(params[:id])
        if @user.update(account_update_params)
          render json: { success: true, data: @user }, status: :ok
        else
          render json: { success: false, errors: [@user.errors] }, status: :unprocessable_entity
        end
      end

      private

      def sign_up_params
        params.permit(:name, :email, :password, :authority_id)
      end

      def account_update_params
        if current_user.authority.admin?
          params.permit(:name, :email, :password, :authority_id)
        else
          params.permit(:name, :email, :password)
        end
      end
    end
  end
end
