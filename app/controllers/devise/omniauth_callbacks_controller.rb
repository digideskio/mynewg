class Devise::OmniauthCallbacksController < DeviseController
  prepend_before_filter { request.env["devise.skip_timeout"] = true }

  def passthru
    render status: 404, text: "Not found. Authentication passthru."
  end

  def failure
    redirect_to request.env["omniauth.params"]["auth_origin_url"]
  rescue
    redirect_to 'http://mynewg.com'
  end

  protected

  def failed_strategy
    env["omniauth.error.strategy"]
  end

  def failure_message
    exception = env["omniauth.error"]
    error   = exception.error_reason if exception.respond_to?(:error_reason)
    error ||= exception.error        if exception.respond_to?(:error)
    error ||= env["omniauth.error.type"].to_s
    error.to_s.humanize if error
  end

  def after_omniauth_failure_path_for(scope)
    new_session_path(scope)
  end

  def translation_scope
    'devise.omniauth_callbacks'
  end
end