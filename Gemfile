source 'https://rubygems.org'

gem 'rails', '4.2.1'
gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass', '3.3.4.1'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks'
gem "bower-rails", "~> 0.9.2"

gem 'devise'
gem 'devise_token_auth'
gem 'omniauth' # required for devise_token_auth
gem 'omniauth-facebook'

gem 'pundit'
gem 'unicorn', platforms: :ruby
gem 'faker'
gem 'pg'

# Image uploader
gem 'mini_magick'
gem 'carrierwave'
gem 'fog'
gem 'unf' # Dependency for fog
gem 'colorize'

# CORS
gem "rack-cors", :require => "rack/cors"

# Pagination
gem 'will_paginate', '~> 3.0.6'

group :production do
  gem 'unicorn-worker-killer'
  gem 'rollbar', '~> 2.2.1'
  gem 'newrelic_rpm'
  gem 'lograge', '~> 0.3.1'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'quiet_assets'
  gem 'capistrano', '~> 2.15'
  gem 'bullet'
  gem 'capistrano-unicorn', require: false, platforms: :ruby
  gem 'thin'
  gem 'spring'
  gem 'capistrano-sidekiq'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'email_spec'
end

group :development, :test do
  gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
  gem 'pry-byebug'
end

gem 'fast_blank'
gem 'jquery-turbolinks'
gem 'compass-rails'
gem 'bourbon'
gem 'font-awesome-sass'
gem 'hashids'
gem 'asset_sync'
gem 'whenever', :require => false
gem 'friendly_id', '~> 5.1.0'
gem 'nested_form'

# Background processing
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sinatra', :require => nil

# Payment processor
gem "omise", "~> 0.1.5"

# Datetimepicker
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.15.35'

# Export to Excel
gem 'acts_as_xlsx'

# Caching
gem 'dalli'

# Language settings
gem 'r18n-rails'