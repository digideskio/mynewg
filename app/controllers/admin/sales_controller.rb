class Admin::SalesController < Admin::BaseController

    def view
        set_sale_transactions
    end

    def commissions
        set_sale_transaction_commissions
    end

    private

    def set_sale_transactions
        @sales ||= SaleTransaction.includes(:package, :package_price).all
    end

    def set_sale_transaction_commissions
        @sale_transaction_commissions ||= current_user.admin? ? SaleTransactionCommission.all : current_user.senior_representative? ? current_user.junior_sale_transaction_commissions : nil
    end
end
