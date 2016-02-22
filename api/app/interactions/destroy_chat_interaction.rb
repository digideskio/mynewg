class DestroyChatInteraction < Interaction
    attr_reader :chat

    def init
       set_chat
       update_related_participant
    end

    def as_json opts = {}
        {

        }
    end

    private

    def set_chat
        @chat = current_user.chats.find(params[:id])
    end

    def update_related_participant
        @chat.current_participant(current_user.id).update_column(:display_messages_from, Time.now)
    end
end
