require Rails.root.join('lib/payatron_4000')

module Cms

    class PayProvider
        attr_reader :user, :price, :card_token, :provider, :discount_code, :reset_notifications

        def initialize data
            @user                           = data[:user]
            @price                          = data[:price]
            @card_token                     = data[:card_token]
            @provider                       = data[:provider]
            @discount_code                  = data[:discount_code]
            @reset_notifications            = data[:reset_notifications]
        end

        def provider
            if @provider == 'omise'
                return Payatron4000::Omiser
            elsif @provider == 'cash'
                return Payatron4000::Casher
            end
        end

        def single
            provider.single(user, price, card_token, discount_code, reset_notifications)
        end

        def recurring
            provider.recurring(user, price, discount_code)
        end
    end
end