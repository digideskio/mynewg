class Api::V1::ChatsController < Api::ApplicationController
    include Api::V1::Concerns::PreventLeadsFromChatting

    def index
        respond_with_interaction ChatsLoadingInteraction
    end

    def show
        respond_with_interaction ChatLoadingInteraction
    end

    def create
        respond_with_interaction CreateChatInteraction
    end

    def read
        respond_with_interaction ReadChatInteraction
    end

    def destroy
        respond_with_interaction DestroyChatInteraction
    end
end
