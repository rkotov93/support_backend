# frozen_string_literal: true
module Api
  module V1
    class UserTokenController < Knock::AuthTokenController
      private

      # Stub to prevent uninitialized constant Api::V1::User
      def entity_name
        'User'
      end

      def auth_token
        if entity.respond_to? :to_token_payload
          AuthToken.new payload: entity.to_token_payload
        else
          entity
        end
      end
    end
  end
end
