module Cms

    class Discounter
        attr_reader :user, :price, :discount_code, :price_type

        def initialize data
            @user               = data[:user]
            @price              = data[:price]
            @discount_code      = data[:discount_code]
            @price_type         = data[:price_type]
        end

        def price
            if code.nil? || invalid_discount_code? || invalid_discount_price_type?
                return @price
            else
                return self.send code.discount_type, @price
            end
        end

        def code
            @code ||= DiscountCode.find_by_code(@discount_code)
        end

        private

        def invalid_discount_code?
             return code.nil? ? true : false
        end

        def invalid_discount_price_type?
            return code.price_type == price_type ? false : true
        end

        def number price
            return price - code.value
        end

        def percentage price
            return price - (price*(code.value/100)) 
        end
    end
end