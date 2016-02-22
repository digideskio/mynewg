class Api::V1::Users::OmniauthCallbacksController < DeviseTokenAuth::ApplicationController
  include CustomError
  rescue_from CustomError::MissingRepresentativeCode, with: :missing_representative_code
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record

  attr_reader :auth_params
  skip_before_filter :set_user_by_token
  skip_after_filter :update_auth_header

  def omniauth_success
    get_resource_from_auth_hash
    
    create_token_info
    set_token_on_resource
    create_auth_params

    Rails.logger.debug "SIGN UP ERRORS"
    Rails.logger.debug "--------------"
    Rails.logger.debug @resource.errors.map{|k,v| v }

    @resource.save!

    if @oauth_registration
      set_profile_photo 
      set_cover_photo
    end

    yield if block_given?

    render_data_or_redirect('deliverCredentials', @auth_params.as_json, @resource.as_json)
  end 

  def omniauth_failure
    redirect_to build_redirect_url(auth_origin_url, nil, false, false, nil)
  end

  protected

  # this will be determined differently depending on the action that calls
  # it. redirect_callbacks is called upon returning from successful omniauth
  # authentication, and the target params live in an omniauth-specific
  # request.env variable. this variable is then persisted thru the redirect
  # using our own dta.omniauth.params session var. the omniauth_success
  # method will access that session var and then destroy it immediately
  # after use.  In the failure case, finally, the omniauth params
  # are added as query params in our monkey patch to OmniAuth in engine.rb
  def omniauth_params
    if !defined?(@_omniauth_params)
      if request.env['omniauth.params'] && request.env['omniauth.params'].any?
        @_omniauth_params = request.env['omniauth.params']
      elsif session['dta.omniauth.params'] && session['dta.omniauth.params'].any?
        @_omniauth_params ||= session.delete('dta.omniauth.params')
        @_omniauth_params
      elsif params['omniauth_window_type']
        @_omniauth_params = params.slice('omniauth_window_type', 'auth_origin_url', 'resource_class', 'origin')
      else
        @_omniauth_params = {}
      end
    end
    @_omniauth_params
    
  end

  # break out provider attribute assignment for easy method extension
  def assign_provider_attrs user, auth_hash
    user.assign_attributes({
      username:       auth_hash['info']['name'],
      name:           auth_hash['info']['name'],
      email:          auth_hash['info']['email'],
      gender:         auth_hash['extra']['raw_info']['gender'],
      role:           'limited',
      facebook_id:    auth_hash['uid'],
      sales_code:     session['representative_code'],
      locale:         session['localisation'].present? || !session['localisation'] == 'null' ? session['localisation'] : 'en_US'
    })
  end

  # Not sure how to fix right now...
  # https://github.com/carrierwaveuploader/carrierwave/issues/1472
  def set_profile_photo
    @resource.profile_photo.update!(file: new_profile_photo_url) unless auth_hash['info']['image'].nil?
  rescue
    return true
  end

  def set_cover_photo
    @resource.cover_photo.update!(file: new_profile_photo_url) unless auth_hash['info']['image'].nil?
  rescue
    return true
  end

  def new_profile_photo_url
    open(secure_image_url)
  end

  def secure_image_url
    auth_hash['info']['image'].gsub("http","https")
  end

  # derive allowed params from the standard devise parameter sanitizer
  def whitelisted_params
    whitelist = devise_parameter_sanitizer.for(:sign_up)

    whitelist.inject({}){|coll, key|
      param = omniauth_params[key.to_s]
      if param
        coll[key] = param
      end
      coll
    }
  end

  def resource_class(mapping = nil)
    if omniauth_params['resource_class']
      omniauth_params['resource_class'].constantize
    elsif params['resource_class']
      params['resource_class'].constantize
    else
      'User'.constantize
    end
  end

  def resource_name
    resource_class
  end

  def omniauth_window_type
    omniauth_params['omniauth_window_type']
  end

  def auth_origin_url
    omniauth_params['auth_origin_url'] || omniauth_params['origin']
  end

  # in the success case, omniauth_window_type is in the omniauth_params.
  # in the failure case, it is in a query param.  See monkey patch above
  def omniauth_window_type
    omniauth_params.nil? ? params['omniauth_window_type'] : omniauth_params['omniauth_window_type']
  end

  # this sesison value is set by the redirect_callbacks method. its purpose
  # is to persist the omniauth auth hash value thru a redirect. the value
  # must be destroyed immediatly after it is accessed by omniauth_success
  def auth_hash
    @_auth_hash ||= session.delete('dta.omniauth.auth')
    @_auth_hash
  end

  # ensure that this controller responds to :devise_controller? conditionals.
  # this is used primarily for access to the parameter sanitizers.
  def assert_is_devise_resource!
    true
  end

  # necessary for access to devise_parameter_sanitizers
  def devise_mapping
    if omniauth_params
      Devise.mappings[omniauth_params['resource_class'].underscore.to_sym]
    else
      request.env['devise.mapping']
    end
  end

  def set_random_password
    # set crazy password for new oauth users. this is only used to prevent
      # access via email sign-in.
      p = SecureRandom.urlsafe_base64(nil, false)
      @resource.password = p
      @resource.password_confirmation = p
  end

  def create_token_info
    # create token info
    @client_id = SecureRandom.urlsafe_base64(nil, false)
    @token     = SecureRandom.urlsafe_base64(nil, false)
    @expiry    = (Time.now + DeviseTokenAuth.token_lifespan).to_i
    @config    = omniauth_params['config_name']
  end

  def create_auth_params
    @auth_params = {
      auth_token:     @token,
      client_id: @client_id,
      uid:       @resource.uid,
      expiry:    @expiry,
      config:    @config
    }
    @auth_params.merge!(oauth_registration: true) if @oauth_registration
    @auth_params
  end

  def set_token_on_resource
    @resource.tokens[@client_id] = {
      token: BCrypt::Password.create(@token),
      expiry: @expiry
    }
  end

  def render_data(message, data)
    @data = data.merge({
      message: message
    })
    render :layout => nil, :template => "devise_token_auth/omniauth_external_window"
  end

  def render_data_or_redirect(message, data, user_data = {})

    # We handle inAppBrowser and newWindow the same, but it is nice
    # to support values in case people need custom implementations for each case
    # (For example, nbrustein does not allow new users to be created if logging in with
    # an inAppBrowser)
    #
    # See app/views/devise_token_auth/omniauth_external_window.html.erb to understand
    # why we can handle these both the same.  The view is setup to handle both cases
    # at the same time.
    if ['inAppBrowser', 'newWindow'].include?(omniauth_window_type)
      render_data(message, user_data.merge(data))

    elsif auth_origin_url # default to same-window implementation, which forwards back to auth_origin_url

      # build and redirect to destination url
      if @oauth_registration ||  @resource.lead?
        redirect_to build_redirect_url(auth_origin_url, '#/onboard/fb-register', true, true, data)
      else
        redirect_to build_redirect_url(auth_origin_url, '#/events', false, true, data)
      end
    else
      
      # there SHOULD always be an auth_origin_url, but if someone does something silly
      # like coming straight to this url or refreshing the page at the wrong time, there may not be one.
      # In that case, just render in plain text the error message if there is one or otherwise 
      # a generic message.
      fallback_render data[:error] || 'An error occurred'
    end
  end

  def fallback_render(text)
      render inline: %Q|

          <html>
                  <head></head>
                  <body>
                          #{text}
                  </body>
          </html>| 
  end

  def get_resource_from_auth_hash
    # find or create user by provider and provider uid
    @resource = resource_class.where({
      uid:      auth_hash['uid'],
      provider: auth_hash['provider']
    }).first_or_initialize

    if @resource.new_record?
      check_for_representative_code
      @oauth_registration = true
      set_random_password
      # sync user info with provider, update/generate auth token
      assign_provider_attrs(@resource, auth_hash)
    end

    # assign any additional (whitelisted) attributes
    extra_params = whitelisted_params
    @resource.assign_attributes(extra_params) if extra_params

    @resource
  end

  def check_for_representative_code
    raise CustomError::MissingRepresentativeCode unless session['representative_code'].present?
  end

  def missing_representative_code
    redirect_to build_redirect_url(auth_origin_url, '#/onboard/fb-register?state=noSalesCode', false, false, nil)
  end

  def invalid_record
    redirect_to build_redirect_url(auth_origin_url, nil, false, false, nil)
  end
  
  def build_redirect_url url, path, onboarding, authenticate, params = {}
    uri = URI(url)

    res = "#{uri.scheme}://#{uri.host}"
    res += ":#{uri.port}" if (uri.port and uri.port != 80 and uri.port != 443)
    res += "#{uri.path}" if uri.path
    res += path if path.present?
    if onboarding && authenticate
      res += "?#{params.to_query}&state=onboarding"
    elsif authenticate
      res += "?#{params.to_query}"
    end
    return res
  end
end