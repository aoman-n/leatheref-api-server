# == Route Map
#
#                  Prefix Verb   URI Pattern                             Controller#Action
#                   hello GET    /hello(.:format)                        application#hello
#                   login POST   /login(.:format)                        sessions#create
#                  logout DELETE /logout(.:format)                       sessions#destroy
#                me_users GET    /users/me(.:format)                     users#me
#                   users POST   /users(.:format)                        users#create
# edit_account_activation GET    /account_activations/:id/edit(.:format) account_activations#edit
#         password_resets POST   /password_resets(.:format)              password_resets#create
#          password_reset PATCH  /password_resets/:id(.:format)          password_resets#update
#                         PUT    /password_resets/:id(.:format)          password_resets#update

Rails.application.routes.draw do
  root to: 'application#hello'

  mount ActionCable.server => '/cable'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  scope :api do
    get '/hello', to: 'application#hello'
    get '/auth/:provider/callback', to: 'sessions#create'
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'

    resources :users, only: [:create, :update], shallow: true do
      get :following, on: :member
      get :followers, on: :member
      get :search, on: :collection
      collection do
        get 'me'
      end
      post :follow, to: 'follows#create', on: :member
      delete :unfollow, to: 'follows#destroy', on: :member
    end
    resources :account_activations, only: [:edit]
    resources :password_resets, only: %i(create update)

    resources :reviews do
      resources :comments, except: %i(index show), shallow: true do
        get :replies, on: :member
        post :likes, to: 'comment_likes#create', on: :member
        delete :likes, to: 'comment_likes#destroy', on: :member
      end
      resources :reactions, only: %i(create destroy), param: :reaction_name
    end

    resources :stores, only: [:index]
    resources :product_categories, only: [:index]

    resources :rooms, only: [:index, :show, :create, :destroy] do
      resources :direct_messages, only: [:create, :destroy], shallow: true
      post :join, to: 'rooms#join', on: :member
      delete :leave, to: 'rooms#leave', on: :member
    end

    resources :communities do
      post :join, on: :member
      delete :leave, on: :member
      resources :join_requests, only: %i(index create show) do
        post :accept, on: :member
        post :reject, on: :member
      end
    end
  end
end
