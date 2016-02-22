class ChatLoadingInteraction < Interaction
    include ChatSerializer
    attr_reader :chat

    def init
        set_chat
    end

    def as_json opts = {}
        {
            chat: serialize_chat(chat)
        }
    end

    private

    def set_chat
        @chat ||= Chat.find(params[:id])
    end
end