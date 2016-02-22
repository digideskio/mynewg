class Admin::MultiCodesController < Admin::BaseController

    def index
        authorize RepresentativeCode
        set_multi_codes
    end

    def new
        authorize RepresentativeCode
        set_representatives
        new_code
    end

    def create
        authorize RepresentativeCode
        set_representatives
        create_code
        if @code.save
            flash[:success] = "Successfully created a multi code."
            redirect_to admin_multi_codes_path
        else
            render :new
        end
    end

    def edit
        authorize RepresentativeCode
        set_representatives
        set_code
    end

    def update
        authorize RepresentativeCode
        set_representatives
        set_code
        if @code.update(representative_code_params)
            flash[:success] = "Successfully updated a mutli code."
            redirect_to admin_multi_codes_path
        else
            render :edit
        end
    end

    def destroy
        authorize RepresentativeCode
        set_code
        @code.destroy
        flash[:success] = "Successfully deleted a mutli code."
        redirect_to admin_multi_codes_path
    end

    private

    def set_code
        @code ||= RepresentativeCode.find(params[:id])
    end

    def set_representatives
        @representatives = User.where(role: %w(1 2))
    end

    def new_code
        @code ||= RepresentativeCode.new
    end

    def create_code
        @code ||= RepresentativeCode.new(representative_code_params)
    end

    def representative_code_params
        params.require(:representative_code).permit(:value, :representative_id, :multi)
    end

    def set_multi_codes
        @codes ||= RepresentativeCode.includes(:representative, :member).multi
    end
end