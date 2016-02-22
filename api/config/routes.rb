Api::Engine.routes.draw do

    namespace :v1 do
        mount_devise_token_auth_for 'User', at: 'auth', skip: [:confirmations], controllers: {
            sessions:               'api/v1/users/sessions',
            token_validations:      'api/v1/users/token_validations',
            omniauth_callbacks:     'api/v1/users/omniauth_callbacks'
        }
        post 'auth/:provider', to: 'users/mobile_registrations#create', as: 'mobile_user_registration'
        resources :users, only: [:show, :update] do
            collection do
                get :discover
                get :me
                get :search
                resources :favourites, controller: 'users/favourites', only: :index
                resources :user_blocks, path: 'block', only: [:create, :destroy]
                resources :user_flags, path: 'flag', only: [:create, :destroy]
                resources :notifications, controller: 'users/notifications', only: :index do
                    patch :read, on: :member
                end
                post :validate_code, to: 'users/codes#validate'
                patch :assign_code, to: 'users/codes#assign'
                resources :registrations, controller: 'users/registrations', only: :create, path: '/'
            end
            resources :attachments, path: 'images', controller: 'users/attachments', only: :index
            resources :events, controller: 'users/events', only: :index
        end
        resources :attachments, path: 'images', only: [:create, :update, :destroy] do
            collection do
                patch :avatar
                patch :cover
            end

            member do
                patch :set_avatar
            end
        end
        resources :likes, only: :create
        resources :events, only: [:index, :show] do
            post :join, on: :collection
            member do
                get :attendees
                delete :unjoin
                post 'invite/:user_id', to: 'events#invite'
            end
        end
        resources :favourites, only: [:create, :destroy]
        resources :appointments, only: :create
        resources :chats, only: [:index, :show, :create, :destroy] do
            resources :messages, only: :index
            patch :read, on: :member
        end
        resources :messages, only: :create
        resources :packages, only: :index
        resources :package_prices, path: 'prices', as: 'prices', only: [] do
            post :purchase, as: 'purchase', on: :member
        end
    end
end
