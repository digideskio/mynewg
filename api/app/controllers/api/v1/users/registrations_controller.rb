class Api::V1::Users::RegistrationsController < Api::ApplicationController
  skip_before_action :authenticate_user!

  def create
    respond_with_interaction CreateUserInteraction
  end
end
