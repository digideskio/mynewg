class Admin::BaseController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :check_if_member
  skip_before_action :user_frozen!
  after_action :verify_authorized
  after_action :skip_authorization

  private

  def check_if_member
    raise Pundit::NotAuthorizedError if current_user.member?
  end
end
