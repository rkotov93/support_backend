# frozen_string_literal: true
require 'rails_helper'
require 'shared/authentication_error'

RSpec.describe 'User registration', type: :request do
  describe 'POST /api/v1/registration' do
    let(:new_user) { build :user }

    context 'with valid parameters' do
      before do
        params = { email: new_user.email, name: new_user.name, password: new_user.password,
                   password_confirmation: new_user.password }
        post api_v1_registration_path, params: { user: params }
      end

      it 'returns created user with JWT' do
        expect(response.status).to eq 200
        expect(response.body).to eq({
          user: {
            id: User.last.id,
            email: new_user.email,
            name: new_user.name,
            jwt: Knock::AuthToken.new(payload: { sub: User.last.id }).token
          }
        }.to_json)
      end
    end

    context 'with invalid parameters' do
      before do
        params = { name: new_user.name, password: new_user.password, password_confirmation: new_user.password }
        new_user.errors.add(:email, :invalid)
        post api_v1_registration_path, params: { user: params }
      end

      it 'returns errors messages' do
        expect(response.status).to eq 406
        expect(response.body).to eq new_user.errors.full_messages.to_json
      end
    end
  end

  describe 'PUT /api/v1/registration' do
    let(:user) { create :user }

    context 'with authenticated user' do
      context 'with valid parameters' do
        before do
          put api_v1_registration_path, headers: { authorization: jwt_for(user) },
                                        params: { user: { email: 'new_email@example.com' } }
        end

        it 'returns updated user' do
          expect(response.status).to eq 200
          expect(response.body).to eq({
            user: {
              id: User.last.id,
              email: 'new_email@example.com',
              name: user.name,
              jwt: Knock::AuthToken.new(payload: { sub: User.last.id }).token
            }
          }.to_json)
        end
      end

      context 'with invalid parameters' do
        before do
          user.errors.add(:email, :invalid)
          put api_v1_registration_path, headers: { authorization: jwt_for(user) },
                                        params: { user: { email: '' } }
        end

        it 'returns errors messages' do
          expect(response.status).to eq 406
          expect(response.body).to eq user.errors.full_messages.to_json
        end
      end
    end

    context 'with not authenticated user' do
      before { put api_v1_registration_path, params: { user: { email: 'new_email@example.com' } } }

      it_behaves_like 'authentication error'
    end
  end

  describe 'DELETE /api/v1/registration' do
    let(:user) { create :user }

    context 'with authenticated user' do
      before { delete api_v1_registration_path, headers: { authorization: jwt_for(user) } }

      it 'deletes user' do
        expect(response.status).to eq 204
      end
    end

    context 'with not authenticated user' do
      before { delete api_v1_registration_path }

      it_behaves_like 'authentication error'
    end
  end
end
