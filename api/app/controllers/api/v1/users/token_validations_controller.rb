class Api::V1::Users::TokenValidationsController < DeviseTokenAuth::ApplicationController
    include UserMeSerializer
    skip_before_filter :assert_is_devise_resource!, :only => [:validate_token]
    before_filter :set_user_by_token, :only => [:validate_token]

    def validate_token
        # @resource will have been set by set_user_token concern
        if @resource
            yield if block_given?
            render json: {
                success: true,
                user: serialize_user(@resource)
            }
        else
            render json: {
                success: false,
                errors: 'Not authorized.'
            }, status: 401
      end
    end
end
