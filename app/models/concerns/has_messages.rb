module HasMessages
    extend ActiveSupport::Concern

    included do
        def unread_messages current_user_id
            recipient_messages(current_user_id).unread
        end

        def recipient_messages current_user_id
            messages.where.not(user_id: current_user_id)
        end

        def active_messages current_user_id
            current_participant(current_user_id).display_messages_from.nil? ? messages : messages.where('created_at > ?', current_participant(current_user_id).display_messages_from)
        end
    end
end
