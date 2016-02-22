class AssignRepresentativeCodeInteraction < Interaction
    include RepresentativeCodeSerializer
    attr_reader :representative_code

    def init
        set_code
        validate_current_user_code
        validate_code
        set_user
        assign_code_to_user
    end

    def as_json opts = {}
        {
            representative_code: serialize_representative_code(representative_code)
        }
    end

    private

    def set_code
        @representative_code ||= RepresentativeCode.available.where('lower(value) = ?', params[:code].downcase).first
    end

    def set_user
        @user ||= current_user
    end

    def validate_code
        raise CustomError::InvalidRepCode if @representative_code.nil?
    end

    def validate_current_user_code
        raise CustomError::CurrentUserRepCodePresent unless current_user.sale_code.nil?
    end

    def assign_code_to_user
        @representative_code.update!(member_id: @user.id, status: 1)
    end
end