class Admin::CodesController < Admin::BaseController

  def view
    authorize RepresentativeCode
    set_assigned_codes
  end

  def new
    authorize RepresentativeCode
    set_representatives
  end

  def create
    authorize RepresentativeCode
    set_representative
    generate_rep_codes

    flash_message :success, "Successfully created #{params[:codes][:count]} representative codes."

    redirect_to view_admin_codes_path
  end

  private

  def generate_rep_codes    
    Cms::RepCode.new(user: @rep_user, type: params[:codes][:type], gender: params[:codes][:gender], count: params[:codes][:count].to_i).multiple
  end

  def set_representative
    @rep_user = User.find(params[:representative_id])
  end

  def set_representatives
    @representatives = User.where(role: %w(1 2))
  end

  def set_assigned_codes
    @codes ||= params[:status] == 'used' ? RepresentativeCode.includes(:representative, :member).used : RepresentativeCode.includes(:representative, :member).assigned.standard.available
  end
end
