# SaleTransaction Documentation
#
# == Schema Information
#
# Table name: sale_transactions
#
#  id                                   :integer          not null, primary key
#  price                                :decimal
#  member_id                            :integer
#  package_price_id                     :integer
#  primary_representative_id            :integer
#  omise_charge_id                      :string(255)
#  payment_type                         :integer
#  discount_code                        :string(255)
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#
class SaleTransaction < ActiveRecord::Base

    belongs_to :member,                                     class_name: 'User', foreign_key: 'member_id'
    belongs_to :primary_representative,                     class_name: 'User'
    belongs_to :package_price
    has_one :package,                                       through: :package_price
    has_many :sale_transaction_commissions,                 dependent: :destroy
    has_many :representatives,                              through: :sale_transaction_commissions, source: :representative

    validates :price, :payment_type,                        presence: true
    validates :omise_charge_id,                             presence: true, :if => :omise?

    enum payment_type: [:cash, :omise]
    enum status: [:pending, :completed, :cancelled]

    def related_representatives
        reps = representatives.to_a.reject {|r| r.id == self.primary_representative.id }
        reps
    end

    def all_representatives
        [member.representative, member.representative.try(:senior)].compact.flatten
    end
end
