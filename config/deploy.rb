set :stages, %w(production staging)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

set :application, 'mynewgirl'
set :scm, 'git'
set :user, 'ubuntu'
set :deploy_to, '/home/rails'
set :repository, 'git@github.com:aparlay/mng-rails.git'
set :scm_verbose, true
set :branch, 'master'

require 'capistrano-unicorn'
require 'capistrano/sidekiq'

# Cron jobs
# set :whenever_command, "whenever"
# require "whenever/capistrano"

# Bundler for remote gem installs
require "bundler/capistrano"

# Rollbar Deploy Tracking
require 'rollbar/capistrano'

# Only keep the latest 3 releases
set :keep_releases, 3
after "deploy:restart", "deploy:cleanup"

set :normalize_asset_timestamps, false

# deploy config
# set :deploy_via, :remote_cache
set :copy_exclude, [".git", ".DS_Store", ".gitignore", ".gitmodules", ".keep"]
set :use_sudo, false

namespace :configure do
  desc "Setup application configuration"
  task :application, :roles => :app do
      run "yes | cp /home/configs/secrets.yml #{deploy_to}/current/config"
  end
  desc "Setup database configuration"
  task :database, :roles => :app do
    run "yes | cp /home/configs/database.yml #{deploy_to}/current/config"
  end
  desc "Update crontab configuration"
  task :crontab, :roles => :app do
    run "cd #{deploy_to}/current && whenever --update-crontab my_new_girl"
  end
end

namespace :database do
    desc "Migrate the database"
    task :migrate, :roles => :app do
      run "cd #{deploy_to}/current && RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
    end
end
namespace :assets do
    desc "Install Bower dependencies"
  task :bower, :roles => :app do
    run "cd #{deploy_to}/current && RAILS_ENV=#{rails_env} bundle exec rake bower:install:deployment"
  end
  desc "Compile assets"
  task :compile, :roles => :app do
    run "cd #{deploy_to}/current && RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end
  desc "Symlink images"
  task :symlink_images, :roles => :app do
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end
end

# additional settings
default_run_options[:shell] = '/bin/bash --login'
default_run_options[:pty] = false

after 'deploy:update_code', 'assets:symlink_images'
after 'sidekiq:stop', 'configure:database'
after 'configure:database', 'configure:application'
after 'configure:application', 'configure:crontab'
after 'configure:crontab', 'database:migrate'
after 'database:migrate', 'assets:bower'
after 'assets:bower', 'assets:compile'
after 'assets:compile', 'unicorn:restart'
