module UserPackagePurchaseValidation
    extend ActiveSupport::Concern

    included do

        private
        
        def validate_user_access
            unless current_user.admin? || current_user.senior_representative? || current_user == @user
                flash[:error] = "You do not have access to this resource."
                redirect_to root_url
            end
        end
    end
end