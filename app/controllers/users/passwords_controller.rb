class Users::PasswordsController < Devise::PasswordsController
    skip_before_action :user_frozen!
end