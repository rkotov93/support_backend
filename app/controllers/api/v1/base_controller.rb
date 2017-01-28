# frozen_string_literal: true
module Api
  module V1
    class BaseController < ApplicationController
      include Knock::Authenticable
      include Pundit

      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

      private

      def user_not_authorized
        render status: :unauthorized
      end
    end
  end
end
