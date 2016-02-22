class Api::V1::FavouritesController < Api::ApplicationController

    def create
        respond_with_interaction CreateFavouriteInteraction
    end

    def destroy
        respond_with_interaction DestroyFavouriteInteraction
    end
end