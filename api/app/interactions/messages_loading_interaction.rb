class MessagesLoadingInteraction < Interaction
    include MessageSerializer
    attr_reader :messages, :paginated_messages, :unread_messages, :page, :limit, :last_message_id

    def init
        set_messages_as_read
    end

    def as_json opts = {}
        # Backwards compatibility for the mobile apps - REMOVE AFTER APPS UPDATED IN LIVE
        if params[:page].present?
            {
                total: paginated_messages.total_entries,
                per_page: limit,
                pages: paginated_messages.total_pages,
                current_page: page,
                messages: paginated_messages.reload.map { |m| serialize_message(m) }
            }
        else
            {
                messages: messages.reload.map { |m| serialize_message(m) }
            }
        end
    end

    private

    def page
        params[:page].present? ? params[:page].to_i : 1
    end

    def limit
        params[:limit].present? ? params[:limit].to_i : 25
    end

    def last_message_id
        params[:last_message_id].present? ? messages.find(params[:last_message_id]).next.try(:id) : messages.last.try(:id)
    end

    def messages
        current_user.chats.find(params[:chat_id]).active_messages(current_user.id)    
    end

    def unread_messages
        messages.where(id: last_message_id..messages.first.id).where.not(user_id: current_user.id)
    end 

    def paginated_messages
        params[:last_message_id].present? ? unread_messages.page(page).per_page(limit) : messages.page(page).per_page(limit)
    end

    def set_messages_as_read
        messages.where.not(user_id: current_user.id).update_all(state: Message.states[:read])
    end
end
