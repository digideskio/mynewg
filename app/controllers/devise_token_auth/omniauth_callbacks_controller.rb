class DeviseTokenAuth::OmniauthCallbacksController < DeviseTokenAuth::ApplicationController

  attr_reader :auth_params
  skip_before_filter :set_user_by_token
  skip_after_filter :update_auth_header
  skip_before_action :user_frozen!

  # intermediary route for successful omniauth authentication. omniauth does
  # not support multiple models, so we must resort to this terrible hack.
  def redirect_callbacks
    # derive target redirect route from 'resource_class' param, which was set
    # before authentication.
    devise_mapping = request.env['omniauth.params']['resource_class'].underscore.to_sym
    redirect_route = "#{request.protocol}#{request.host_with_port}/v1/auth/#{params[:provider]}/callback"

    # preserve omniauth info for success route. ignore 'extra' in twitter
    # auth response to avoid CookieOverflow.
    session['dta.omniauth.auth'] = request.env['omniauth.auth']
    session['dta.omniauth.params'] = request.env['omniauth.params']

    set_query_params
    assign_representative_code_session
    assign_locale_session

    redirect_to redirect_route
  end

  protected

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

  def resource_class(mapping = nil)
    if omniauth_params['resource_class']
      omniauth_params['resource_class'].constantize
    elsif params['resource_class']
      params['resource_class'].constantize
    else
      raise "No resource_class found"
    end
  end

  def resource_name
    resource_class
  end

  # necessary for access to devise_parameter_sanitizers
  def devise_mapping
    if omniauth_params
      Devise.mappings[omniauth_params['resource_class'].underscore.to_sym]
    else
      request.env['devise.mapping']
    end
  end

  def assign_representative_code_session
    session.delete('representative_code')
    session['representative_code'] = @code unless @code.nil?
  end

  def assign_locale_session
    unless @locale.nil?
      session.delete('localisation')
      session['localisation'] = @locale 
    end
  end

  def set_query_params
    @code = request.env['omniauth.params']['code']
    @locale = request.env['omniauth.params']['locale']
  rescue
    @locale = nil
    @code = nil
  end
end