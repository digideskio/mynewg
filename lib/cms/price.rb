module Cms

    class Price < AbstractController::Base
        attr_reader :price
        include ActionView::Helpers::NumberHelper

        # Initial price logic which builds attributes to force behaviour, not data interaction
        #
        # @overload set(data)
        #   @param [Decimal] price
        # @return [Decimal] price
        def initialize data
            @price      = data[:price]
        end

        # Convert a price into an integer
        #
        # @return [integer] price
        def singularize
            (price * 100).round
        end

        # Returns a formatted single price.
        #
        # @return [String] formatted price
        def single
            format(price)
        end

        private

        # Rounds the decimal price down to two decimal places and adds the currency set in the store settings, returning the value
        # Returns nil if the parameter is nil
        #
        # @param [Decimal] price
        # @return [String] price with currency
        def format price
            price.nil? ? nil : number_to_currency(price, unit: '฿', precision: 0)
        end
    end
end