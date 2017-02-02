# frozen_string_literal: true
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :registration, only: [:create, :update, :destroy]
      post 'user_token' => 'user_token#create'

      resources :tickets do
        get :active, on: :collection
        post :change_status, on: :member
        resources :comments, only: [:index, :create, :destroy]
      end

      resources :users do
        get :me, on: :collection
        post :change_role, on: :member
      end

      namespace :pdf_reports do
        post :generate
        get :info
      end
    end
  end
end
