class Api::V1::Users::SessionsController < DeviseTokenAuth::ApplicationController
    include Api::V1::Concerns::SetUserByToken
    include Api::V1::Concerns::CustomControllerErrors
    include UserMeSerializer
    before_filter :set_user_by_token, :only => [:destroy]
    after_action :reset_session, :only => [:destroy]

    def new
      render json: {
        errors: [ I18n.t("devise_token_auth.sessions.not_supported")]
      }, status: 405
    end

    def create
      # Check
      field = resource_params[:facebook_id].present? ? :facebook_id : (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first

      @resource = nil
      if field
        q_value = resource_params[field]

        if resource_class.case_insensitive_keys.include?(field)
          q_value.downcase!
        end

        if resource_params[:facebook_id].present?
          @resource = resource_class.where(facebook_id: resource_params[:facebook_id]).first
        else
          @resource = resource_class.where(['lower(phone) = :value OR lower(email) = :value', { :value => q_value }]).first
        end
      end

      if @resource and valid_params?(field, q_value) and validate_password and (!@resource.respond_to?(:active_for_authentication?) or @resource.active_for_authentication?)
        # create client id
        @client_id = SecureRandom.urlsafe_base64(nil, false)
        @token     = SecureRandom.urlsafe_base64(nil, false)

        @resource.tokens[@client_id] = {
          token: BCrypt::Password.create(@token),
          expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
        }
        @resource.save

        sign_in(:user, @resource, store: false, bypass: false)

        yield if block_given?

        render json: {
          user: serialize_user(@resource)
        }

      elsif @resource and not (!@resource.respond_to?(:active_for_authentication?) or @resource.active_for_authentication?)
        render json: {
          success: false,
          errors: [ I18n.t("devise_token_auth.sessions.not_confirmed", email: @resource.email) ]
        }, status: 401

      else
        render json: {
          errors: [I18n.t("devise_token_auth.sessions.bad_credentials")]
        }, status: 401
      end
    end

    def destroy
      # remove auth instance variables so that after_filter does not run
      user = remove_instance_variable(:@resource) if @resource
      client_id = remove_instance_variable(:@client_id) if @client_id
      remove_instance_variable(:@token) if @token

      if user and client_id and user.tokens[client_id]
        user.tokens.delete(client_id)
        user.save!

        yield if block_given?

        render json: {
          success:true
        }, status: 200

      else
        render json: {
          errors: [I18n.t("devise_token_auth.sessions.user_not_found")]
        }, status: 404
      end
    end

    def valid_params?(key, val)
      resource_params[:facebook_id].present? ? true : (resource_params[:password] && key && val)
    end

    def resource_params
      params.permit(devise_parameter_sanitizer.for(:sign_in))
    end

    def validate_password
      resource_params[:facebook_id].present? ? true : @resource.valid_password?(resource_params[:password])
    end

    def get_auth_params
      auth_key = nil
      auth_val = nil

      # iterate thru allowed auth keys, use first found
      resource_class.authentication_keys.each do |k|
        if resource_params[k]
          auth_val = resource_params[k]
          auth_key = k
          break
        end
      end

      # honor devise configuration for case_insensitive_keys
      if resource_class.case_insensitive_keys.include?(auth_key)
        auth_val.downcase!
      end

      return {
        key: auth_key,
        val: auth_val
      }
    end
end