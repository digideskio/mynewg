module HasDiscountCodes
    extend ActiveSupport::Concern

    included do
        has_one :active_discount_code_user,                              -> { where(status: 0) }, class_name: 'DiscountCodeUser', foreign_key: 'user_id', dependent: :destroy      
        has_one :active_discount_code,                                   through: :active_discount_code_user, source: :discount_code      

        has_many :archived_discount_code_users,                          -> { where(status: 1) }, class_name: 'DiscountCodeUser', foreign_key: 'user_id', dependent: :destroy
        has_many :archived_discount_codes,                               through: :archived_discount_code_users, source: :discount_code

        has_one :single_discount_code,                                   -> { where(price_type: 0) }, through: :active_discount_code_user, source: :discount_code, dependent: :destroy
        has_one :recurring_discount_code,                                -> { where(price_type: 1) }, through: :active_discount_code_user, source: :discount_code, dependent: :destroy
    end
end