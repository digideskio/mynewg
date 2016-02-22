class CreateUserInteraction < Interaction
    include UserParamable
    include UserMeSerializer
    attr_reader :user

    def init
        create_user
    end

    def as_json opts = {}
        {
            user: serialize_user(user)
        }
    end

    private

    def create_user
        @user = User.create!(user_params.merge(role: 4))
    end
end
