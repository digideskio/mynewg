module SetUser
    extend ActiveSupport::Concern

    included do
        
        private

        def set_user
            @user = User.find_by_username(params[:username])
        end
    end
end