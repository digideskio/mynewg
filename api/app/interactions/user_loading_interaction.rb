class UserLoadingInteraction < Interaction
    include UserSerializer
    attr_reader :user

    def init
        set_user
    end

    def as_json opts = {}
        {
            user: serialize_user(user)
        }
    end

    private

    def set_user
        @user ||= User.includes(:profile_photo, :cover_photo).find(params[:id])
    end
end