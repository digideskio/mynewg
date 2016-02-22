class Package < ActiveRecord::Base

  has_many :prices,                                   class_name: 'PackagePrice', dependent: :destroy
  has_many :sale_transactions,                        through: :prices
  has_many :commissions,                              through: :prices, source: :commissions
  has_many :members,                                  class_name: 'User'

  has_many :package_events
  has_many :events, through: :package_events

  has_many :discount_code_packages
  has_many :discount_codes,                           through: :discount_code_packages

  validates :name, :tier, :description,               presence: true
  validates :tier,                                    uniqueness: true
  validate :price_count,                              :if => :published?

  scope :available,                                   ->(current_tier)  { where('tier > ?', current_tier) }
  scope :active,                                      -> { where.not(status: 2) }

  default_scope { order(tier: :asc) }

  enum status: [:draft, :published, :archived]
  enum chat_status: [:chat_disabled, :chat_enabled]

  accepts_nested_attributes_for :prices

  def price_count
    if self.prices.map(&:package_id).count == 0
      errors.add(:package, " must have at least one price.")
      return false
    end
  end

  def single_price gender
    prices.where(interval: 0, gender: PackagePrice.genders[gender]).first
  end

  def monthly_price gender
    prices.where(interval: 30, gender: PackagePrice.genders[gender]).first
  end

  def purchased? user
    members.include?(user)
  end

  def purchased_all? user
    !user.package.nil? && (user.package.tier > tier || purchased?(user))
  end

  def gender_prices user
    return user.male? ? prices.active.male : prices.active.female
  end
end
