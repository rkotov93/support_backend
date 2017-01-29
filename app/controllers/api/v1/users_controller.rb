module Api
  module V1
    class UsersController < BaseController
      before_action :authorize_admin!

      def index
        render json: User.without(current_user).page(params[:page] || 1)
      end

      def destroy
        user = User.find(params[:id])
        user.destroy
        render json: user
      end

      def change_role
        user = User.find(params[:id])
        role = User.roles.keys.find { |r| r == params[:role] }
        user.public_send("#{role}!") if role
        render json: user
      end

      private

      def authorize_admin!
        authorize User
      end
    end
  end
end
