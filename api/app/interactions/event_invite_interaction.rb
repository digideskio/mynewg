class EventInviteInteraction < Interaction

    def init
        set_event
        set_invited_user
        validate_attendee_count
        validate_already_attending
        create_invite_notification
    end

    def as_json opts = {}
        {
            
        }
    end

    private

    def set_event
        @event ||= Event.find(params[:id])
    end

    def set_invited_user
        @user ||= User.find(params[:user_id])
    end

    def validate_attendee_count
        raise CustomError::MaxAttendee if @event.maximum_attendees? 
    end

    def validate_already_attending
        raise CustomError::AlreadyAttending if @event.attending?(@user)
    end

    def create_invite_notification
        @notification = @user.invite_notifications.create(source_id: current_user.id, event_id: @event.id)
        raise ActiveRecord::RecordInvalid.new(@notification) unless @notification.valid?
    end
end