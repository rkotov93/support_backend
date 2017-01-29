# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'User authentication', type: :request do
  let(:user) { create :user }

  describe 'POST /api/v1/user_token' do
    context 'with correct credentials' do
      before { post api_v1_user_token_path, params: { auth: { email: user.email, password: user.password } } }

      it 'returns user info with JWT' do
        expect(response.status).to eq 201
        expect(response.body).to eq({
          user: {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
            jwt: Knock::AuthToken.new(payload: { sub: user.id }).token
          }
        }.to_json)
      end
    end

    context 'with wrong credentials' do
      before { post api_v1_user_token_path, params: { auth: { email: user.email, password: 'wrong_password' } } }

      it 'returns user info with JWT' do
        expect(response.status).to eq 404
        expect(response.body).to eq ''
      end
    end
  end
end
