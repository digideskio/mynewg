Rails.application.routes.draw do

    get '/locale/:locale', to: 'locales#change'

    constraints(AccountSubdomain) do

        root to: 'pages#landing'

        devise_for :users, skip: [:confirmations, :registrations], :controllers =>
        {
            sessions: 'users/sessions',
            passwords: 'users/passwords'
        }

        get :terms, to: 'pages#terms'
        get :privacy, to: 'pages#privacy'
        get :contact, to: 'pages#contact'

        namespace :admin do
            root to: 'dashboard#index'
            authenticate :user do
                mount Sidekiq::Web => 'secret-route-666/sidekiq'
            end

            resources :members, only: %i(new create edit update index destroy) do
                collection do
                    get :charts
                    get :view
                    get :incomplete
                    get :export
                end
            end

            resources :codes, only: %i(index new create) do
                get :view, on: :collection
            end

            resources :scratch_codes, only: [:index, :new, :create] do
                collection do
                    get :edit
                    patch :assign
                    get :export
                end
            end

            resources :multi_codes, except: [:show]

            resources :discounts, controller: 'discount_codes', except: [:show] do
                get :view, on: :collection
            end

            resources :sales, only: %i(index) do
                collection do
                    get :print
                    get :download
                    get :email
                    get :charts
                    get :view
                    get :commissions
                end
            end

            resources :events, except: :show do
                get :view, on: :collection
            end

            resources :user_flags, path: 'flags', only: :index

            resources :packages, except: [:show, :create] do
                get :view, on: :collection
                resources :package_prices, path: 'prices', except: [:index, :show]
                resources :package_price_commissions, path: 'commissions', except: [:index, :show]
            end
        end

        scope '/:username', controller: :users do
            resources :packages, only: :index
            get 'purchase/:package', to: 'packages#purchase', as: 'user_purchase_package'            
            post 'complete/:package', to: 'packages#complete', as: 'user_complete_package'
            get 'success/:package', to: 'packages#success', as: 'user_success_package'
            get 'failed/:package', to: 'packages#failed', as: 'user_failed_package'
        end
    end

    constraints(ApiSubdomain) do
        mount Api::Engine, at: '/'
    end
end
