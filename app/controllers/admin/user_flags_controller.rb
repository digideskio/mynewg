class Admin::UserFlagsController < Admin::BaseController

    def index
        set_user_flags
    end

    private

    def set_user_flags
        @user_flags ||= UserFlag.all
    end
end