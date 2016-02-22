require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MyNewGirl
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')

    config.autoload_paths += %W(#{config.root}/api/lib)

    config.before_initialize do
        Api::Engine.instance.initializers.map{ |e| e.run Rails.application }
    end

    config.middleware.insert_before Warden::Manager, Rack::Cors do
        allow do
            origins '*'
            resource '*',
                :headers => :any,
                :methods => [:get, :post, :put, :patch, :delete, :options],
                :expose  => ['access-token', 'client', 'uid', 'expiry', 'token-type'],
                :max_age => 600
        end
    end

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Bangkok'
    # config.active_record.default_timezone = :local

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
        g.test_framework :rspec,
            fixtures: true,
            view_specs: false,
            helper_specs: false,
            routing_specs: false,
            controller_specs: true,
            feature_specs: true
        g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    config.autoload_paths += %W(#{Rails.root}/lib
                                #{Rails.root}/api/app/serializers
                                #{Rails.root}/api/app/interactions
                                #{Rails.root}/api/app/interactions/concerns)
  end
end
