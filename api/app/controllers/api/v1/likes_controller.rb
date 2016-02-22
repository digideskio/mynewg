class Api::V1::LikesController < Api::ApplicationController

    def create
        respond_with_interaction CreateLikeInteraction
    end
end