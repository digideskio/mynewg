class LocalesController < ApplicationController
  def change
    locale = params[:locale].to_sym

    session[:locale] = locale if I18n.available_locales.include?(locale)

    redirect_to :back
  end
end
