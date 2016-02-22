class DiscountCodeUsersController < ApplicationController
    include SetUser
    before_action :authenticate_user!

    def validate
        set_user
        set_package_price
        set_package
        set_discount_code
        unless @discount_code.nil? || !@discount_code.valid_code?(@package, @user)
            calculate_price
            render json: {  message: 'Yay! Valid discount code.', 
                            code: @discount_code.code, 
                            price: Cms::Price.new(price: @price).single, 
                            price_type: @discount_code.price_type 
                        }, status: 200
        else
            render json: { error: 'Invalid discount code.' }, status: 422
        end
    end

    private

    def calculate_price
        @price = Cms::Discounter.new(user: @user, price: @package_price.value, discount_code: params[:discount_code], price_type: @discount_code.price_type).price
    end

    def set_discount_code
        @discount_code ||= DiscountCode.find_by_code(params[:discount_code])
    end

    def set_package_price
        @package_price ||= PackagePrice.find(params[:id])
    end

    def set_package
        @package ||= @package_price.package
    end
end