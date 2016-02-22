# PackagePriceCommission Documentation
#

# == Schema Information
#
# Table name: package_price_commissions
#
#  id                     :integer          not null, primary key
#  role                   :integer        
#  value                  :decimal    
#  package_price_id       :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class PackagePriceCommission < ActiveRecord::Base

    belongs_to :package_price
    has_one :package,                                                   through: :package_price
    has_many :sale_transaction_commissions

    validates :role, :value, :package_price_id, :status,                presence: true
    validates :role,                                                    uniqueness: { scope: :package_price_id, message: 'commission has already been assigned for this package price.' }
    validates :value,                                                   uniqueness: { scope: [:role, :package_price_id] }, :if => :active?     

    enum role: [:junior_representative, :senior_representative]
    enum status: [:active, :archived]
end