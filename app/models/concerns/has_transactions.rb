module HasTransactions
    extend ActiveSupport::Concern

    included do
        has_many :member_transactions,                      class_name: 'SaleTransaction', foreign_key: 'member_id', dependent: :destroy
        has_many :member_transaction_commission,            through: :member_transactions, source: :sale_transaction_commissions
        has_many :representative_transactions,              through: :sale_transaction_commissions, source: :sale_transaction

        def sale_transactions
            member? ? member_transactions : (junior_representative? || senior_representative?) ? representative_transactions : nil
        end
    end
end