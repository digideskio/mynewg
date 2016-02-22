class UserPolicy < ApplicationPolicy
    attr_reader :current_user, :user

    def initialize current_user, model
        @current_user = current_user
        @user = model
    end

    def index? ; admin_or_senior_representative?; end
    def show? ; admin_or_current_user?; end
    def new? ; admin_or_senior_representative?; end
    def edit? ; admin_or_senior_representative?; end
    def create? ; admin_or_senior_representative?; end
    def update? ; admin_or_senior_representative?; end
    def destroy? ; admin_or_senior_representative?; end
    def view? ; admin_or_senior_representative?; end
    def export? ; admin_or_senior_representative?; end
    
    def incomplete? ; admin_or_senior_representative?; end

    private

    def admin?
        @current_user.admin?
    end

    def admin_or_senior_representative?
        @current_user.admin? || @current_user.senior_representative?
    end

    def admin_or_current_user?
        @current_user == @user || @current_user.admin?
    end
end
