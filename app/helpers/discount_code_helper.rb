module DiscountCodeHelper

    def discount_type discount
        discount.number? ? Cms::Price.new(price: discount.value).single : "#{discount.value}%"
    end
end