class UserSearchInteraction < Interaction
    include UserSerializer
    attr_reader :users

    def init
        @users = User.includes(:profile_photo, :cover_photo).where(name: params[:query])
    end

    def as_json opts = {}
        {
            users: users.map { |u| serialize_user(u) }
        }
    end
end
