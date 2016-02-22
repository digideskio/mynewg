class UpdateUserInteraction < Interaction
    include UserParamable
    include UserSerializer
    attr_reader :user

    def init
        set_user
        update_user
    end

    def as_json opts = {}
        {
            user: serialize_user(user)
        }
    end

    private

    def set_user
        @user ||= User.find(params[:id])
    end

    def update_user
        @user.update(user_params)
    end
end
