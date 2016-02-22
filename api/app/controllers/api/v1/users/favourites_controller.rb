class Api::V1::Users::FavouritesController < Api::ApplicationController

    def index
        respond_with_interaction FavouritesLoadingInteraction
    end
end