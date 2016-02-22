class PackagePriceCommissionPolicy < ApplicationPolicy
    attr_reader :current_user, :model

    def initialize current_user, model
        @current_user = current_user
        @user = model
    end

    def new? ; admin?; end
    def create? ; admin? end
    def edit? ; admin?; end
    def update? ; admin?; end
    def destroy? ; admin?; end

    private

    def admin?
        @current_user.admin?
    end

end
