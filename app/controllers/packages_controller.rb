class PackagesController < ApplicationController
    include SetUser
    include UserPackagePurchaseValidation
    
    def index
        set_user
        # validate_user_access
        set_packages
    end

    def purchase
        set_user
        # validate_user_access
        set_package
        set_package_price
        validate_package_access
        validate_package_price_presence
        new_card
        # if @user.paid_by_cash
        #   validate_cash_amount
        # else
        #   validate_card
        # end
    end

    def complete
        set_user
        # validate_user_access
        set_package
        set_package_price
        validate_package_access
        validate_package_price_presence
        new_card
        if assign_or_create_card
            # if @user.paid_by_cash
            #     validate_cash_amount
            #     charge_user('cash')
            # else
            # validate_card
            charge_user('omise')
            # end
            if @charge.authorized
                unless discount_code_blank?
                    archive_discount_code_user
                    create_discount_code_user
                end
                upgrade_package
                upgrade_role
                send_confirmation_email
                # UserActivator.new(@user).activate!
                redirect_to user_success_package_path(@user.username, @package.name.downcase)
            else
                redirect_to user_failed_package_path(@user.username, @package.name.downcase)
            end
        else
            redirect_to user_purchase_package_path(@user.username, @package.name.downcase)
        end
    end

    def success
        set_user
        # validate_user_access
        set_package
        set_package_price
    end

    def failed
        set_user
        # validate_user_access
        set_package
        set_package_price
    end

    private

    def new_card
        @card ||= Card.new
    end

    def set_package
        @package ||= Package.where('lower(name) = ?', params[:package].downcase).first
    end

    def set_packages
        @packages ||= @user.package.nil? ? Package.published.all : Package.available(@user.package.tier).published.all
    end

    def set_package_price
        @package_price ||= @package.single_price(@user.gender)
    end

    def assign_or_create_card
        @card = Card.new(card_params)
        if @card.valid?
            @new_card = @user.customer.cards.create(
                name: card_params[:name],
                number: card_params[:number],
                expiration_month: card_params[:expiration_month],
                expiration_year: card_params[:expiration_year],
                security_code: card_params[:security_code]
            )
        else
            return false
        end
    end

    def charge_user provider
        @charge = Cms::PayProvider.new(user: @user, price: @package_price, provider: provider, card_token: @new_card.id, discount_code: params[:discount_code], reset_notifications: true).single
    end

    def upgrade_package
        @user.update_column(:package_id, @package.id)
    end

    def upgrade_role
        @user.update_column(:role, 0)
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

    def validate_package_access
        unless @user.valid_package_price_gender?(@package_price) && @user.valid_package_tier?
            flash_message :error, "You do not have permission to purchase this package."
            redirect_to root_path
        end
    end

    def validate_card
        unless @user.valid_card?(@new_card.id)
            flash_message :error, "Invalid card."
            redirect_to billing_user_path(@user.username)
        end
    end

    def validate_package_price_presence
        if @package.single_price(@user.gender).nil? || @package.monthly_price(@user.gender).nil?
            flash_message :error, "You do not have permission to purchase this package."
            redirect_to root_path
        end
    end

    def discount_code_blank?
        params[:discount_code].nil? || params[:discount_code].blank? ? true : false
    end

    def validate_cash_amount
        if @user.cash_amount < @package_price.value
            flash_message :error, "You haven't enough cash in your account for this package."
            redirect_to billing_user_path(@user.username)
        end
    end

    def card_params
        params.require(:card).permit(:name, :number, :expiration_month, :expiration_year, :security_code)
    end
end