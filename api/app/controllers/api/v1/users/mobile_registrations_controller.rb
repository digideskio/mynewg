class Api::V1::Users::MobileRegistrationsController < Api::ApplicationController
    include CustomError
    rescue_from CustomError::MissingRepresentativeCode, with: :missing_representative_code
    include UserParamable
    include UserMeSerializer
    skip_before_action :authenticate_user!

    def create
        check_for_representative_code
        build_user
        set_random_password
        create_token_info
        set_token_on_user

        @user.save!

        set_response_headers
        render json: { user: serialize_user(@user) }, status: 200
    end

    private

    def build_user
        @user = User.new(user_params)
        @user.role = 'limited'
        @user.provider = 'facebook'
        @user.uid = user_params[:facebook_id]
        @user.username = user_params[:name]
    end

    def set_random_password
        p = SecureRandom.urlsafe_base64(nil, false)
        @user.password = p
        @user.password_confirmation = p
    end

    def create_token_info
        # create token info
        # Check if expiry changes in devise_token_auth initializer - 14.days by default
        @client_id = SecureRandom.urlsafe_base64(nil, false)
        @token     = SecureRandom.urlsafe_base64(nil, false)
        @expiry    = (Time.now + 14.days).to_i
        @config    = 'Bearer'
    end

    def set_token_on_user
        @user.tokens[@client_id] = {
            token: BCrypt::Password.create(@token),
            expiry: @expiry
        }
    end

    def set_response_headers
        response.headers["access-token"]    = @token
        response.headers["client"]          = @client_id
        response.headers["uid"]             = @user.uid
        response.headers["expiry"]          = @expiry
        response.headers["token-type"]      = @config
    end

    def check_for_representative_code
        raise CustomError::MissingRepresentativeCode unless user_params[:sales_code].present? && RepresentativeCode.valid_code?(user_params[:sales_code])
    end

    def missing_representative_code
        render json: { errors: "Invalid sales code. Please contact support." }, status: 422
    end
end