class CreateMessageInteraction < Interaction
    include MessageSerializer
    attr_reader :message

    def init
        set_chat
        set_other_user
        validate_users_can_chat
        create_message
    end

    def as_json opts = {}
        {
            message: serialize_message(message)
        }
    end

    private

    def set_chat
        @chat ||= current_user.chats.find(message_params[:chat_id])
    end

    def set_other_user
        @other_user = @chat.other_user(current_user)
    end

    def validate_users_can_chat
        raise CustomError::ChatDisabled unless current_user.can_chat?(@other_user)
    end

    def create_message
        @message = current_user.messages.create(message_params)
        raise ActiveRecord::RecordInvalid.new(@message) unless @message.valid?
    end

    def message_params
        params.require(:message).permit(:text, :chat_id)
    end
end