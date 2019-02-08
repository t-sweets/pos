# frozen_string_literal: true

module Api
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      before_action :authenticate_admin, only: [:create]
      before_action :authenticate_admin_and_login_user, only: [:update]

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
