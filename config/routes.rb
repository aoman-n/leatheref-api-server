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

  scope :api do
    get '/hello', to: 'application#hello'
    get '/auth/:provider/callback', to: 'sessions#create'
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'

    resources :users, only: [:create] do
      collection do
        get 'me'
      end
    end
    resources :account_activations, only: [:edit]
    resources :password_resets, only: %i(create update)

    resources :reviews, shallow: true do
      resources :comments, except: %i(index show) do
        get :replies, on: :member
        post :likes, to: 'comment_likes#create', on: :member
        delete :likes, to: 'comment_likes#destroy', on: :member
      end
    end

    resources :stores, only: [:index]
    resources :product_categories, only: [:index]
  end
end
