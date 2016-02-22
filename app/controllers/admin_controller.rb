class AdminController < ApplicationController
    layout 'admin_old'
    before_action :authenticate_user!
    before_action :check_if_member
    after_action :verify_authorized
    skip_before_action :user_frozen!

    private

    def check_if_member
        raise Pundit::NotAuthorizedError if current_user.member?
    end
end