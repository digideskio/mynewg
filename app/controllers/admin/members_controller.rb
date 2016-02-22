class Admin::MembersController < Admin::BaseController
  include OmiseCreditCardHelper
  include DecomposeDatetime

  def view
    authorize User
    set_members
  end

  def new
    authorize User
    set_packages
    @member = User.new
    @member.build_profile_photo
  end

  def edit
    authorize User
    set_member
    set_packages
    set_junior_reps if @member.senior_representative?
    @member.build_profile_photo if @member.profile_photo.nil?
  end

  def index
    authorize User
  end

  def create
    authorize User
    set_packages
    @member = User.new(member_params)
    set_junior_reps if @member.senior_representative?
    change_cash_amount
    if @member.save
      reset_billing_notifications
      redirect_to view_admin_members_url
    else
      render :new
    end
  end

  def update
    authorize User
    set_member
    set_packages
    set_junior_reps if @member.senior_representative?
    create_card(@member) unless params[:card].nil?
    change_cash_amount
    if @member.update(member_params)
      reset_billing_notifications
      redirect_to view_admin_members_url
    else
      render :edit
    end
  end

  def destroy
    authorize User
    set_member
    reset_event_attendee_count
    destroyable_user? ? @member.destroy : @member.update_column(:status, 2)
    redirect_to view_admin_members_url
  end

  def incomplete
    authorize User
    set_limited
  end

  def export
    authorize User
    set_members

    send_data @members.to_csv, filename: "members-#{Date.today}.csv"
  end

  private

  def set_member
    @member = User.find(params[:id])
  end

  def set_members
    @members ||= params[:status].present? ? User.includes(:package, :representative).where(status: params[:status]).all : User.includes(:package, :representative).active.all
  end

  def set_packages
    @packages = Package.active.all.map{|p| [p.name, p.id]}
  end

  def set_junior_reps
    @junior_reps ||= User.junior_representative
  end

  def set_limited
    @leads = User.where(role: 5)
  end

  def change_cash_amount
    cash_changes = params[:user][:cash_amount].to_f
    @member.cash_amount += cash_changes if cash_changes != 0
    @member.save
    params[:user].delete :cash_amount
  end

  def reset_billing_notifications
    @member.reset_billing_notifications if @member.package_id_changed?
  end

  def reset_event_attendee_count
    Cms::reset_counter_caches(@member.attending_events, :attendees)
  end

  def member_params
    params.require(:user)
          .permit(:name, :email, :gender, :sales_code, :date_of_birth, :location, :profile_video_url, :waive_join_fee,
                  :password, :password_confirmation, :phone, :line_id, :username, :display_name, :role, :status, :paid_by_cash,
                  :age, :drink, :english, :height, :kids, :smoke, :thai, :visible, :package_id, :platinum, :biography, :locale,
                  profile_photo_attributes: [:_destroy, :id, :file], gallery_photos_attributes: [:_destroy, :id, :file], junior_ids: [])
  end

  def destroyable_user?
    @member.member? || @member.lead? || @member.limited?
  end
end
