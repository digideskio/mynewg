module HasCommissions
    extend ActiveSupport::Concern

    included do
        has_many :sale_transaction_commissions,                              class_name: 'SaleTransactionCommission', foreign_key: 'representative_id', dependent: :destroy
        has_many :sale_transaction_pending_commissions,                      -> { where(status: 0) }, class_name: 'SaleTransactionCommission', foreign_key: 'representative_id', dependent: :destroy
        has_many :sale_transaction_completed_commissions,                    -> { where(status: 1) }, class_name: 'SaleTransactionCommission', foreign_key: 'representative_id', dependent: :destroy

        has_many :junior_sale_transaction_commissions,                       through: :juniors, source: :sale_transaction_commissions

        has_many :commissions,                                               through: :sale_transaction_commissions, source: :price
        has_many :pending_commissions,                                       through: :sale_transaction_pending_commissions, source: :price
        has_many :completed_commissions,                                     through: :sale_transaction_completed_commissions, source: :price
    end
end

