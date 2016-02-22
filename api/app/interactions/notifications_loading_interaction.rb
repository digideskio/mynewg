class NotificationsLoadingInteraction < Interaction
    include NotificationSerializer
    attr_reader :notifications

    def init
        @notifications = current_user.notifications.active.all
    end

    def as_json opts = {}
        {
            notifications: notifications.map { |n| serialize_notification(n) }
        }
    end
end