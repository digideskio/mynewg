class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :configure_permitted_parameters, :if => :devise_controller?
  before_action :user_frozen!
  before_action :set_locale

  include Pundit
  include ApplicationHelper
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized exception
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    if current_user.member? || current_user.limited?
      redirect_to discover_path
    else
      redirect_to admin_old_root_path
    end
  end

  def user_frozen!
    redirect_to frozen_user_path(current_user.username) if user_signed_in? && current_user.member? && current_user.freeze?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in).push(:login, :phone, :password, :remember_me, :facebook_id)
    devise_parameter_sanitizer.for(:sign_up).push(:name, :role, :gender, :sales_code, :username, :facebook_id)
    devise_parameter_sanitizer.for(:account_update).push(:name, :role, :gender, :sales_code, :username, :password, :password_confirmation, :current_password)
  end

  def after_sign_in_path_for resource
    if resource.member? || resource.limited?
      upgrade_package_user_path(resource.username)
    else
      admin_root_path
    end
  end

  def after_sign_up_path_for resource
    upgrade_package_user_path(current_user.username)
  end

  def after_update_path_for resource
    upgrade_package_user_path(current_user.username)
  end

  def set_locale
    I18n.locale = session[:locale].present? ? session[:locale] : :en
  end
end
