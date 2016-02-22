class Api::V1::PackagesController < Api::ApplicationController

    def index
        respond_with_interaction PackagesLoadingInteraction
    end
end
