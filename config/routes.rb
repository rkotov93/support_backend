# frozen_string_literal: true
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :registration, only: [:create, :update, :destroy]
      post 'user_token' => 'user_token#create'

      resources :tickets do
        post :change_status, on: :member
      end

      resources :users do
        post :change_role, on: :member
      end
    end
  end
end
