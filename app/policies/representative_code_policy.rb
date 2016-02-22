class RepresentativeCodePolicy < ApplicationPolicy
    attr_reader :current_user, :model

    def initialize current_user, model
        @current_user = current_user
        @user = model
    end

    def index? ; admin_or_senior_representative?; end
    def view? ; admin_or_senior_representative?; end
    def new? ; admin?; end
    def create? ; admin?; end
    def scratch? ; admin?; end
    def assign? ; admin?; end
    def edit? ; admin?; end
    def update? ; admin?; end
    def export? ; admin?; end
    def destroy? ; admin?; end

    private

    def admin?
        @current_user.admin?
    end

    def admin_or_senior_representative?
        @current_user.admin? || @current_user.senior_representative?
    end
end
