class Admin::ScratchCodesController < Admin::BaseController

  def index
    authorize RepresentativeCode
    set_assigned_scratch_codes
  end

  def new
    authorize RepresentativeCode
  end

  def create
    authorize RepresentativeCode
    generate_scratch_codes

    flash_message :success, "Successfully created #{params[:codes][:count]} scratch codes."

    redirect_to admin_codes_path
  end

  def edit
    authorize RepresentativeCode
    set_representatives
    set_unassigned_scratch_codes
  end

  def assign
    authorize RepresentativeCode
    set_representatives
    set_unassigned_scratch_codes
    if valid_code_count?
      set_representative
      assign_codes
      flash[:success] = "Successfully assigned #{params[:codes][:count]} scratch codes to #{@rep_user.name}!"
      redirect_to admin_codes_path
    else
      flash[:error] = "You only have #{@codes.count} unassigned scratch codes."
      render :edit
    end
  end

  def export
    authorize RepresentativeCode
    set_unassigned_scratch_codes

    send_data @codes.to_csv, filename: "unassigned-scratch-codes-#{Date.today}.csv"
  end

  private

  def generate_scratch_codes
    Cms::ScratchCode.new(count: params[:codes][:count].to_i).multiple
  end

  def set_representatives
    @representatives = User.where(role: %w(1 2))
  end

  def set_assigned_scratch_codes
    @codes ||= RepresentativeCode.includes(:representative, :member).scratch.assigned.available
  end

  def set_unassigned_scratch_codes
    @codes ||= RepresentativeCode.includes(:representative, :member).unscoped.scratch.unassigned.available.order(scratch_barcode: :asc)
  end

  def set_representative
    @rep_user = User.find(params[:representative_id])
  end

  def assign_codes
    @codes.first(params[:codes][:count]).map{|c| c.update_column(:representative_id, @rep_user.id) }
  end

  def valid_code_count?
    return params[:codes][:count].to_i > @codes.count ? false : true
  end
end
