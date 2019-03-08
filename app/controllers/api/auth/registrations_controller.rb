# frozen_string_literal: true

module Api
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      before_action :authenticate_admin, only: [:create]

      def create
        super
      end

      private

      def sign_up_params
        unless params[:password]
          password = [*'A'..'Z', *'a'..'z', *0..9].sample(16).join
          params[:password] = password
        end
        params.permit(:name, :email, :password, :authority_id)
      end

      def log_audit(model, operation)
        AuditLog.create(model: 'user', model_id: model.id, operation: operation, operator: current_user.id)
      end
    end
  end
end
