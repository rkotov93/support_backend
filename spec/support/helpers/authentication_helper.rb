# frozen_string_literal: true
def jwt_for(user)
  token = Knock::AuthToken.new(payload: { sub: user.id }).token
  "Bearer #{token}"
end
