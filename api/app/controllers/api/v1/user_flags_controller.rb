class Api::V1::UserFlagsController < Api::ApplicationController

    def create
        respond_with_interaction CreateUserFlagInteraction
    end

    def destroy
        respond_with_interaction DestroyUserFlagInteraction
    end
end