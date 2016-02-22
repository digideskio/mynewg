# SaleTransactionCommission Documentation
#
# == Schema Information
#
# Table name: sale_transaction_commissions
#
#  id                                   :integer          not null, primary key
#  status                               :integer
#  payment_type                         :integer         
#  sale_transaction_id                  :integer
#  package_price_commission_id          :integer
#  represenative_id                     :integer
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#
class SaleTransactionCommission < ActiveRecord::Base

    belongs_to :sale_transaction
    belongs_to :price,                                                      class_name: 'PackagePriceCommission', foreign_key: 'package_price_commission_id'
    belongs_to :representative,                                             class_name: 'User', foreign_key: 'representative_id'

    has_many :related_representatives,                                      through: :sale_transaction
    has_one :member,                                                        through: :sale_transaction
    has_one :primary_representative,                                        through: :sale_transaction
    has_one :package_price,                                                 through: :sale_transaction
    has_one :package,                                                       through: :sale_transaction

    delegate :related_representatives,                                      to: :sale_transaction

    validates :status, :sale_transaction_id, 
    :package_price_commission_id, :representative_id,
    :payment_type,                                                          presence: true

    enum status: [:pending, :completed, :cancelled]
    enum payment_type: [:cash, :omise]
end
