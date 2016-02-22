class Users::SessionsController < Devise::SessionsController
    skip_before_action :user_frozen!
end