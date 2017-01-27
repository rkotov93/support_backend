# frozen_string_literal: true
module Api
  module V1
    class UserTokenController < Knock::AuthTokenController
      private

      # Stub to prevent uninitialized constant Api::V1::User
      def entity_name
        'User'
      end
    end
  end
end
