# DiscountCode Documentation
#
# == Schema Information
#
# Table name: discount_codes
#
#  id                     :integer          not null, primary key
#  code                   :integer
#  value                  :decimal
#  gender                 :integer
#  discount_type          :integer
#  price_type             :integer
#  public                 :boolean          default(true)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class DiscountCode < ActiveRecord::Base

    has_many :discount_code_packages,           dependent: :destroy
    has_many :packages,                         through: :discount_code_packages

    has_many :discount_code_users,              dependent: :restrict_with_exception
    has_many :users,                            through: :discount_code_users

    validates :code, :value, :gender,
    :discount_type, :price_type,                presence: true

    validates :code,                            uniqueness: true

    enum gender: [:female, :male, :both]
    enum discount_type: [:number, :percentage]
    enum price_type: [:single, :recurring]

    def valid_code? package, user
        valid_package?(package) && valid_gender?(user) && valid_access?(user)
    end

    def valid_package? package
        return packages.include?(package) ? true : false
    end

    def valid_gender? user
        return both? || gender == user.gender ? true : false
    end

    def valid_access? user
        return public? || !user.member? ? true : false
    end
end
