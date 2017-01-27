# frozen_string_literal: true
def jwt_for(user)
  post api_v1_user_token_path, params: { auth: { email: user.email, password: user.password } }
  "Bearer #{JSON.parse(response.body)['jwt']}"
end
