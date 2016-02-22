class JoinEventInteraction < Interaction
    include EventAttendeeSerializer

    def init
        set_event
        validate_package_access
        validate_attendee_count
    end

    def as_json opts = {}
        {
            event_attendee: serialize_event_attendee(event_attendee)
        }
    end

    private

    def event_attendee
        current_user.attending_event_managements.create!(event_attendee_params)
    end

    def set_event
        @event ||= Event.find(event_attendee_params[:event_id])
    end

    def event_attendee_params
        params.require(:event_attendee).permit(:event_id)
    end

    def validate_package_access
        raise CustomError::PackageAccess unless @event.can_attend?(current_user)
    end

    def validate_attendee_count
        raise CustomError::MaxAttendee if @event.maximum_attendees? 
    end
end
