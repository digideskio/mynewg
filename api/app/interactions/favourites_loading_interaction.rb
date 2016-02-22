class FavouritesLoadingInteraction < Interaction
    include UserSerializer
    attr_reader :favourites

    def init
        set_favourites
    end

    def as_json opts = {}
        {
            users: favourites.map { |u| serialize_user(u) }
        }
    end

    private

    def set_favourites
        @favourites ||= current_user.favourites.includes(:profile_photo, :cover_photo).all
    end
end