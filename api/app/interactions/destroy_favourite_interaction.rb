class DestroyFavouriteInteraction < Interaction
    attr_reader :favourite

    def init
        set_favourite
        destroy_favourite
    end

    def as_json opts = {}
        {

        }
    end

    private

    def set_favourite
        @favourite = current_user.user_favourites.find(params[:id])
    end

    def destroy_favourite
        @favourite.destroy
    end
end