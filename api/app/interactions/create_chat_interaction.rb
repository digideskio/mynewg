class CreateChatInteraction < Interaction
    include ChatSerializer
    attr_reader :chat, :other_user_id

    def init
        set_target_user
        validate_users_can_chat
        create_chat
    end

    def as_json opts = {}
        {
            chat: serialize_chat(chat)
        }
    end

    private

    def set_target_user
        @other_user ||= User.find(other_user_id)
    end

    def other_user_id
        # Backwards compatibility for the mobile apps - REMOVE AFTER APPS UPDATED IN LIVE
        (params[:chat].present? && params[:chat][:recipient_id].present?) ? params[:chat][:recipient_id] : params[:chat_user_id]
    end

    def validate_users_can_chat
        raise CustomError::ChatDisabled unless current_user.can_chat?(@other_user)
    end

    def create_chat
        @chat = Chat.create!(participants_attributes: [
            {
                user_id: current_user.id
            },
            {
                user_id: @other_user.id
            }
        ])
    end

    # def chat_params
    #     params.require(:chat).permit(:recipient_id, :chat_user_id)
    # end
end