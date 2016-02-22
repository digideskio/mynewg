class SaleTransactionCommissionPolicy < ApplicationPolicy
    attr_reader :current_user, :model

    def initialize current_user, model
        @current_user = current_user
        @user = model
    end

    def complete? ; admin_or_senior_representative?; end

    private

    def admin_or_senior_representative?
        @current_user.admin? || @current_user.senior_representative?
    end
end
