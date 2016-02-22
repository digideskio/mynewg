class Admin::PackagePriceCommissionsController < ApplicationController

  def new
    authorize PackagePriceCommission
    set_package
    new_commission
    render json: { modal: render_to_string(partial: 'admin/packages/commissions/modal', locals: { url: admin_package_package_price_commissions_path, method: 'POST' }) }, status: 200
  end

  def edit
    authorize PackagePriceCommission
    set_package
    set_commission
    render json: { modal: render_to_string(partial: 'admin/packages/commissions/modal', locals: { url: admin_package_package_price_commission_path, method: 'PATCH' }) }, status: 200
  end

  def create
    authorize PackagePriceCommission
    set_package
    @commission = PackagePriceCommission.new(package_price_commission_params)

    if @commission.save
        if @package.commissions.active.count == 1
            render json: { first_record: true, table: render_to_string(partial: 'admin/packages/commissions/table', object: @package) }, status: 200
        else
            render json: { commission_id: @commission.id, first_record: false, row: render_to_string(partial: 'admin/packages/commissions/single', locals: { commission: @commission }) }, status: 200
        end
    else
        render json: { errors: @commission.errors.full_messages }, status: 422        
    end
  end

  def update
    authorize PackagePriceCommission
    set_commission

    if @commission.update(package_price_commission_params)
        render json: { commission_id: @commission.id, first_record: false, row: render_to_string(partial: 'admin/packages/commissions/single', locals: { commission: @commission }) }, status: 200
    else
        render json: { errors: @commission.errors.full_messages }, status: 422
    end
  end

  def destroy
    authorize PackagePriceCommission
    set_commission
    set_package
    commission_id = @commission.id
    if @commission.sale_transaction_commissions.empty?
        @commission.destroy
    else
        @commission.archived!
    end
    if @package.commissions.active.empty?
        render json: { last_record: true, html: '<div class="helper-notification"><p>You do not have any commissions for this package.</p><i class="icon-coin"></i></div>' }
    else
        render json: { last_record: false, commission_id: commission_id }
    end
  end

  private

  def new_commission
      @commission ||= PackagePriceCommission.new
  end

  def set_commission
      @commission ||= PackagePriceCommission.find(params[:id])
  end

  def set_package
      @package ||= Package.find(params[:package_id])
  end

  def package_price_commission_params
      params.require(:package_price_commission).permit(:status, :value, :role, :package_price_id)
  end
end
