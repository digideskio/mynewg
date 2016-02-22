class Api::V1::UserBlocksController < Api::ApplicationController

    def create
        respond_with_interaction CreateUserBlockInteraction
    end

    def destroy
        respond_with_interaction DestroyUserBlockInteraction
    end
end