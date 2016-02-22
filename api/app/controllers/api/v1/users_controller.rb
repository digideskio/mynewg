class Api::V1::UsersController < Api::ApplicationController

    def discover
        respond_with_interaction UsersLoadingInteraction
    end

    def me
        respond_with_interaction UserMeLoadingInteraction
    end

    def show
        respond_with_interaction UserLoadingInteraction
    end

    def search
        respond_with_interaction UserSearchInteraction
    end

    def update
        respond_with_interaction UpdateUserInteraction
    end
end