# frozen_string_literal: true
module Api
  module V1
    class RegistrationsController < BaseController
      before_action :authenticate_user, except: :create

      def create
        user = User.new(user_params)
        if user.save
          render json: user
        else
          render json: user.errors.full_messages, status: :not_acceptable
        end
      end

      def update
        if current_user.update_attributes(user_params)
          render json: current_user
        else
          render json: current_user.errors.full_messages, status: :not_acceptable
        end
      end

      delegate :destroy, to: :current_user

      private

      def user_params
        params.require(:user).permit(:email, :name, :password, :password_confirmation)
      end
    end
  end
end
