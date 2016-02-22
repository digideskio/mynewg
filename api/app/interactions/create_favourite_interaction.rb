class CreateFavouriteInteraction < Interaction
    include FavouriteSerializer
    attr_reader :favourite

    def init
        create_favourite
    end

    def as_json opts = {}
        {
            favourite: serialize_favourite(favourite)
        }
    end

    private

    def create_favourite
        @favourite = current_user.user_favourites.create(favourite_params)
        raise ActiveRecord::RecordInvalid.new(@favourite) unless @favourite.valid?
    end

    def favourite_params
        params.require(:favourite).permit(:favourite_id)
    end
end