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

      # Pagination meta for serialization
      def pagination_dict(collection)
        {
          current_page: collection.current_page,
          total_pages: collection.total_pages,
          total_count: collection.count
        }
      end
    end
  end
end
