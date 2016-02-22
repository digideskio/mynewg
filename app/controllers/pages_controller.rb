class PagesController < ApplicationController

    def show
        render "pages/#{params[:page]}", format: [:html]
    end

    def landing
    end
end