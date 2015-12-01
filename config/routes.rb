Rails.application.routes.draw do
  devise_for :user, only: []

  namespace :v1, defaults: { format: :json } do
    resource :login, only: [:create], controller: :sessions
    resource :logout, only: [:destroy], controller: :sessions

    # resources :phones, only: [:update, :show]
    resources :addresses, only: [:index, :create, :show]
    resources :users, only: [:create, :update, :show] do
      resources :orders, only: [:index, :create, :show, :update, :destroy]
    end

    get '/users/:id/stripe-id', to: 'users#stripe_id', as: 'user_stripe_id'

    # Why arent these just nested routes?
    get '/users/:user_id/phones', to: 'phone_users#index', as: 'get_user_phones'
    get '/users/:user_id/phones/:id', to: 'phone_users#show', as: 'user_phone'
    post '/users/:user_id/phones', to: 'phone_users#create', as: 'post_user_phones'
    put '/users/:user_id/phones/:id', to: 'phone_users#update', as: 'put_user_phones'

    get '/users/:user_id/addresses', to: 'address_users#index', as: 'get_user_addresses'
    get '/users/:user_id/addresses/:id', to: 'address_users#show', as: 'user_address'
    post '/users/:user_id/addresses', to: 'address_users#create', as: 'post_user_addresses'
    put '/users/:user_id/addresses/:id', to: 'address_users#update', as: 'put_user_addresses'

    post '/signup', to: 'users#signup', as: 'users_signup'
    post '/sign-in', to: 'sessions#create_from_email', as: 'users_signin'
  end
end
