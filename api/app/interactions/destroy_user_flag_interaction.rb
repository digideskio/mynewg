class DestroyUserFlagInteraction < Interaction
    attr_reader :user_flag

    def init
        set_user_flag
        destroy_user_flag
    end

    def as_json opts = {}
        {

        }
    end

    private

    def set_user_flag
        @user_flag = current_user.user_flags.find_by_flagged_id(params[:id])
    end

    def destroy_user_flag
        @user_flag.destroy
    end
end