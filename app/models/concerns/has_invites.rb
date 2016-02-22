module HasInvites
    extend ActiveSupport::Concern

    included do
        after_create :send_attending_notifications
    end

    private

    def send_attending_notifications
        notifications = attendee.invite_notifications.active.where(event_id: event.id)
        return if notifications.empty?
        notifications.each do |n|
            notify = n.source.attending_notifications.build(event_id: event.id, source_id: attendee.id)
            n.archived! if notify.save
        end
    end
end