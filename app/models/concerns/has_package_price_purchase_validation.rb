module HasPackagePricePurchaseValidation
    extend ActiveSupport::Concern

    included do
        def valid_package_price_gender? package_price
            gender == package_price.gender ? true : false
        end

        def valid_card? card_token
            customer.cards.retrieve(card_token)
        rescue
            return false
        end

        def valid_package_tier?
            !package.nil? && package.tier == Package.last.tier ? false : true
        end
    end
end