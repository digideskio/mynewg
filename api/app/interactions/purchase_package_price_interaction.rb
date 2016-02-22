class PurchasePackagePriceInteraction < Interaction

    def init
        set_user
        set_package_price
        set_package
        validate_price
        validate_package_access
        validate_card
        charge_user
        if @charge.authorized
            unless discount_code_blank?
                archive_discount_code_user
                create_discount_code_user
            end
            upgrade_package
            send_confirmation_email
            UserActivator.new(@user).activate!
        end
    end

    def as_json opts = {}
        {
            success: true,
            amount: @charge.amount,
            charge_id: @charge.id,
            transaction_id: @charge.transaction.id,
            created_at: @charge.created,
        }
    end

    private

    def set_user
        @user ||= current_user
    end

    def set_package_price
        @package_price ||= PackagePrice.active.find(params[:id])
    end

    def set_package
        @package ||= @package_price.package
    end

    def validate_package_access
        raise CustomError::PackagePurchase unless @user.valid_package_price_gender?(@package_price) && @user.valid_package_tier?
    end

    def validate_card
        raise CustomError::InvalidCard unless @user.valid_card?(params[:card_token])
    end

    def validate_price
        raise CustomError::InvalidOmisePrice unless @package_price.valid_omise_price?
    end

    def upgrade_package
        @user.update_column(:package_id, @package.id)
    end

    def charge_user
        @charge = Cms::PayProvider.new(user: @user, price: @package_price, provider: 'omise', card_token: params[:card_token], discount_code: params[:discount_code], reset_notifications: true).single
    end

    def archive_discount_code_user
        @user.active_discount_code_user.archived! if @user.active_discount_code_user
    end

    def create_discount_code_user
        @discount_code = DiscountCode.find_by_code(params[:discount_code])
        @user.create_active_discount_code_user(discount_code_id: @discount_code.id) if @discount_code.valid_code?(@package, @user)
    end

    def send_confirmation_email
        MemberMailer.package_purchase(@user).deliver_later
    end

    def discount_code_blank?
        params[:discount_code].blank? || params[:discount_code].nil? ? true : false
    end
end