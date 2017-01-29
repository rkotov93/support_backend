# frozen_string_literal: true
require 'rails_helper'
require 'shared/authentication_error'

RSpec.describe 'Users', type: :request do
  let!(:admin) { create :user, role: 'admin' }
  let!(:user1) { create :user }
  let!(:user2) { create :user }

  describe 'GET /users' do
    context 'as admin user' do
      before { get api_v1_users_path, headers: { authorization: jwt_for(admin) } }

      it 'returns users list' do
        expect(response.status).to eq 200
        expect(response.body).to eq({
          users: [user_hash(user1), user_hash(user2)]
        }.to_json)
      end
    end

    %w(customer support).each do |role|
      context "as #{role} user" do
        before do
          user1.public_send("#{role}!")
          get api_v1_users_path, headers: { authorization: jwt_for(user1) }
        end

        it_behaves_like 'authentication error'
      end
    end
  end

  describe 'DELETE /users/:id' do
    context 'as admin user' do
      let!(:users_count) { User.count }

      before { delete api_v1_user_path(user1), headers: { authorization: jwt_for(admin) } }

      it 'deletes user' do
        expect(response.status).to eq 200
        expect(User.count).to eq users_count - 1
      end
    end

    %w(customer support).each do |role|
      context "as #{role} user" do
        before do
          user1.public_send("#{role}!")
          delete api_v1_user_path(user2), headers: { authorization: jwt_for(user1) }
        end

        it_behaves_like 'authentication error'
      end
    end
  end

  describe 'POST /users/:id/change_role' do
    context 'as admin user' do
      before do
        post change_role_api_v1_user_path(user1), headers: { authorization: jwt_for(admin) },
                                                  params: { role: 'support' }
      end

      it 'returns users list' do
        expect(response.status).to eq 200
        expect(user1.reload.role).to eq 'support'
      end
    end

    %w(customer support).each do |role|
      context "as #{role} user" do
        before do
          user1.public_send("#{role}!")
          post change_role_api_v1_user_path(user2), headers: { authorization: jwt_for(user1) },
                                                    params: { role: 'support' }
        end

        it_behaves_like 'authentication error'
      end
    end
  end
end
