# frozen_string_literal: true
def user_hash(user)
  {
    id: user.id,
    email: user.email,
    name: user.name,
    role: user.role,
    jwt: Knock::AuthToken.new(payload: { sub: user.id }).token
  }
end
