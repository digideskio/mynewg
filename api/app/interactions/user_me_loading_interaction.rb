class UserMeLoadingInteraction < Interaction
    include UserMeSerializer
    attr_reader :user

    def init
        @user = User.includes(:profile_photo, :cover_photo).find(current_user.id)
    end

    def as_json opts = {}
        {
            user: serialize_user(user)
        }
    end
end