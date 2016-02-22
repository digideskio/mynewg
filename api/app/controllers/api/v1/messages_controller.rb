class Api::V1::MessagesController < Api::ApplicationController
    include Api::V1::Concerns::PreventLeadsFromChatting

    def index
        respond_with_interaction MessagesLoadingInteraction
    end

    def create
        respond_with_interaction CreateMessageInteraction
    end
end