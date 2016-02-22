class ReadNotificationInteraction < Interaction
    include NotificationSerializer
    attr_reader :notification

    def init
        set_notification
        mark_as_read
    end

    def as_json opts = {}
        {
            notification: serialize_notification(notification)
        }
    end

    private

    def set_notification
        @notification ||= current_user.notifications.find(params[:id])
    end

    def mark_as_read
        @notification.read!
    end
end