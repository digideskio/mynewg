class Admin::PackagesController < Admin::BaseController

  def view
    clean_drafts
    authorize Package
    set_packages
  end

  def new
    authorize Package
    new_package
    redirect_to edit_admin_package_path(@package)
  end

  def edit
    authorize Package
    set_package
  end

  def update
    authorize Package
    set_package
    @package.attributes = package_params
    @package.save(validate: false)
    if params[:commit] == "Save As Draft"
      @package.status = :draft
      package_params[:status] = 'draft'
      @message = "Your package has been saved successfully as a draft."
    elsif params[:commit] == "Publish"
      @package.status = :published
      package_params[:status] = 'published'
      @message = "Your package has been published successfully. It is now live."
    end
    if @package.update(package_params)
      flash_message :success, @message
      redirect_to admin_packages_url
    else
      render :edit
    end
  end

  def destroy
    authorize Package
    set_package
    if @package.sale_transactions.empty? && @package.members.empty?
      @package.destroy
      flash_message :success, 'Package was successfully deleted.'
    else
      @package.archived!
      flash_message :success, 'Package was successfully archived.'
    end  
    redirect_to admin_packages_url
  end

  private

  def new_package
    @package = Package.new
    @package.save(validate: false)
  end

  def clean_drafts
    Package.where("name = :blank_value OR name IS :nil_value", nil_value: nil, blank_value: '').destroy_all
  end

  def set_package
    @package ||= Package.find(params[:id])
  end

  def set_packages
    @packages ||= Package.active.includes(:prices).all
  end

  def package_params
    params.require(:package).permit(:name, :status, :tier, :description, :chat_status, :prices_attributes => [:id, :interval, :gender, :value, :package_id])
  end
end
