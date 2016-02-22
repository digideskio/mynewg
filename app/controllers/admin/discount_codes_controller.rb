class Admin::DiscountCodesController < Admin::BaseController

    def index
        authorize DiscountCode
    end

    def view
        authorize DiscountCode
        set_discount_codes
    end

    def new
        authorize DiscountCode
        new_discount_code
        set_packages
    end

    def edit
        authorize DiscountCode
        set_discount_code
        set_packages
    end

    def create
        authorize DiscountCode
        @discount_code = DiscountCode.new(discount_code_params)
        set_packages
        if @discount_code.save
            redirect_to view_admin_discounts_url
        else
            render :new
        end
    end

    def update
        authorize DiscountCode
        set_discount_code
        set_packages
        if @discount_code.users.empty?
            if @discount_code.update(discount_code_params)
                redirect_to view_admin_discounts_url
            else
                render :edit
            end
        else
            flash[:error] = 'You cannot edit a discount code which is in use by users.'
            redirect_to view_admin_discounts_url
        end
    end

    def destroy
        authorize DiscountCode
        set_discount_code
        if @discount_code.users.empty?
            @discount_code.destroy
            redirect_to view_admin_discounts_url
        else
            flash[:error] = 'You cannot destroy a discount code which is in use by users.'
            redirect_to view_admin_discounts_url
        end
    end

    private

    def set_discount_code
        @discount_code ||= DiscountCode.find(params[:id])
    end

    def new_discount_code
        @discount_code = DiscountCode.new
    end

    def set_discount_codes
        @discount_codes ||= DiscountCode.includes(:packages).all
    end

    def set_packages
        @packages ||= Package.published
    end

    def discount_code_params
        params.require(:discount_code).permit(:code, :value, :gender, :discount_type, :price_type, :public, package_ids: [])
    end
end