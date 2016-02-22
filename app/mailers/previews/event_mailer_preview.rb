class EventMailerPreview < ActionMailer::Preview

    def reminder
        set_user
        set_event
        EventMailer.reminder(@user, @event)
    end

    private

    def set_event
        @event ||= Event.first
    end

    def set_user
        @user ||= User.member.first
    end
end
