# PackagePrice Documentation
#
# == Schema Information
#
# Table name: package_prices
#
#  id                       :integer          not null, primary key
#  gender                   :integer
#  interval                 :integer
#  value                    :decimal          default(0)
#  package_id               :integer
#  status                   :integer          default(0)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class PackagePrice < ActiveRecord::Base

    belongs_to :package
    has_many :sale_transactions,                                    dependent: :restrict_with_exception
    has_many :members,                                              through: :sale_transactions
    has_many :commissions,                                          class_name: 'PackagePriceCommission', dependent: :destroy
    has_many :billing_notifications,                                dependent: :destroy

    validates :gender, :package_id, :interval, :value,              presence: true
    validates :interval,                                            uniqueness: { scope: [:package_id, :gender] }, :if => :active?

    validate :price_value


    enum gender: [:female, :male]
    enum status: [:active, :archived]

    def single?
        return interval == 0 ? true : false
    end

    def interval?
        return interval != 0 ? true : false
    end

    def valid_omise_price?
        (value * 100).round < 2000 ? false : true
    end

    def price_value
        unless value >= 20 || value == 0
            errors.add(:value, "must be 20+ or 0")
        end
    end
end
