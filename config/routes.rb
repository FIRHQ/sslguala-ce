require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :check_domains, only: %i[show destroy create update index] do
        collection do
          get :valid
          get :welcome
          post :batch_create
        end
        member do
          post :check_now
        end
      end
      resources :projects, only: %i[show destroy create update index] do
        member do
          post :add_domains
        end
      end
      resources :msg_channels, only: %i[show destroy create update index] do
        member do
          post :bind
          post :unbind
          post :try_send_message
          post :multiple_bind
        end
      end

      resources :users, only: [] do
        collection do
          post :reset_token
          get :info
        end
      end

      # API TOKEN
      get 'api_tokens/check_domains',     to: "api_tokens#check_domains"
      get 'api_tokens/valid',           to: "api_tokens#valid"
      get 'api_tokens/msg_channels',   to: "api_tokens#msg_channels"
      get 'api_tokens/projects',   to: "api_tokens#projects"
      post 'api_tokens/create_domain',  to: "api_tokens#create_domain"
      post 'api_tokens/destroy_domain', to: "api_tokens#destroy_domain"
    end
  end
  get 'home/index'
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations',
               passwords: 'users/passwords',
               omniauth_callbacks: 'users/omniauth_callbacks'
             }
  root to: 'madmin/users#index'

  get 'policy', to: 'home#policy'

  # admin
  namespace :madmin do
    resources :msg_channels
    root to: "dashboard#index"
    resources :user_omniauths
    resources :check_domains
    resources :users
    resources :projects
  end
end
