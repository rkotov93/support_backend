# frozen_string_literal: true
class UserSerializer < ActiveModel::Serializer
  attributes :email, :name, :jwt

  def jwt
    if object.respond_to? :to_token_payload
      Knock::AuthToken.new(payload: object.to_token_payload).token
    else
      Knock::AuthToken.new(payload: { sub: object.id }).token
    end
  end
end
