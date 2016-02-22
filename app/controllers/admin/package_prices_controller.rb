class Admin::PackagePricesController < AdminController

    def new
        authorize PackagePrice
        set_package
        new_package_price
        render json: { modal: render_to_string(partial: 'admin/packages/prices/modal', locals: { url: admin_package_package_prices_path, method: 'POST' }) }, status: 200
    end

    def create
        authorize PackagePrice
        set_package
        @price = @package.prices.build(package_price_params)
        if @price.save
            if @package.prices.count == 1
                render json: { first_record: true, table: render_to_string(partial: 'admin/packages/prices/table', object: @package) }, status: 200
            else
                render json: { price_id: @price.id, first_record: false, row: render_to_string(partial: 'admin/packages/prices/single', locals: { price: @price }) }, status: 200
            end
        else
            render json: { errors: @price.errors.full_messages }, status: 422        
        end
    end

    def edit
        authorize PackagePrice
        set_package
        set_package_price
        render json: { modal: render_to_string(partial: 'admin/packages/prices/modal', locals: { url: admin_package_package_price_path, method: 'PATCH' }) }, status: 200
    end

    def update
        authorize PackagePrice
        set_package_price

        if @price.update(package_price_params)
            render json: { price_id: @price.id, first_record: false, row: render_to_string(partial: 'admin/packages/prices/single', locals: { price: @price }) }, status: 200
        else
            render json: { errors: @price.errors.full_messages }, status: 422
        end
    end

    def destroy
        authorize PackagePrice
        set_package
        set_package_price
        price_id = @price.id
        if @price.sale_transactions.empty? && @price.members.empty?
            @price.destroy
        else
            @price.archived!
            @price.commissions.update_all(status: 1)
        end  
        if @package.prices.active.empty?
            render json: { last_record: true, html: '<div class="helper-notification"><p>You do not have any prices for this package.</p><i class="icon-coin"></i></div>' }
        else
            render json: { last_record: false, price_id: price_id }
        end
    end

    private

    def new_package_price
        @price ||= @package.prices.build
    end

    def set_package_price
        @price ||= PackagePrice.find(params[:id])
    end

    def set_package
        @package ||= Package.find(params[:package_id])
    end

    def package_price_params
        params.require(:package_price).permit(:interval, :gender, :value, :package_id)
    end
end
