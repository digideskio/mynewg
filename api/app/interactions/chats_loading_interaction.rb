class ChatsLoadingInteraction < Interaction
    include ChatSerializer
    attr_reader :chats

    def init
        @chats = current_user.chats.all
    end

    def as_json opts = {}
        {
            chats: chats.map { |c| serialize_chat(c) }
        }
    end
end