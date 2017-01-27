class UserSerializer < ActiveModel::Serializer
  attributes :email, :name, :jwt

  def jwt
    Knock::AuthToken.new(payload: { sub: User.first.id }).token
  end
end
