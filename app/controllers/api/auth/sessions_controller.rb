# frozen_string_literal: true

module Api
  module Auth
    class SessionsController < DeviseTokenAuth::SessionsController
      before_action :set_email, only: [:create]

      def create
        super
      end

      private

      def set_email
        user = User.find_by(name: params[:name])
        params[:email] = user.email if user
      end
    end
  end
end
