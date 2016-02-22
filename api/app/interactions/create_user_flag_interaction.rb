class CreateUserFlagInteraction < Interaction
    include UserFlagSerializer
    attr_reader :user_flag

    def init
        create_user_flag
    end

    def as_json opts = {}
        {
            user_flag: serialize_user_flag(user_flag)
        }
    end

    private

    def create_user_flag
        @user_flag = current_user.user_flags.create(user_flag_params)
        raise ActiveRecord::RecordInvalid.new(@user_flag) unless @user_flag.valid?
    end

    def user_flag_params
        params.require(:user_flag).permit(:flagged_id, :reason, :additional_info)
    end
end