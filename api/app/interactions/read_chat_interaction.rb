class ReadChatInteraction < Interaction
    include ChatSerializer
    attr_reader :chat

    def init
        set_chat
        mark_all_as_read
    end

    def as_json opts = {}
        {
            chat: serialize_chat(chat)
        }
    end

    private

    def set_chat
        @chat ||= current_user.chats.find(params[:id])
    end

    def mark_all_as_read
        @chat.messages.unread.update_all(state: 1)
    end
end