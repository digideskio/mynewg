class EventPolicy < ApplicationPolicy
    attr_reader :current_user, :model

    def initialize current_user, model
        @current_user = current_user
        @user = model
    end

    def index? ; admin?; end
    def show? ; logged_in?; end
    def new? ; admin?; end
    def edit? ; admin?; end
    def create? ; admin?; end
    def update? ; admin?; end
    def destroy? ; admin?; end
    def check_in? ; admin?; end
    def view? ; admin?; end

    private

    def admin?
        @current_user.admin?
    end

    def logged_in?
        current_user.nil? ? false : true
    end
end
