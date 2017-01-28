# frozen_string_literal: true
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :registration, only: [:create, :update, :destroy]
      post 'user_token' => 'user_token#create'

      resources :tickets
    end
  end
end
