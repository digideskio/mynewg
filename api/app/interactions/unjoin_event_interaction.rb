class UnjoinEventInteraction < Interaction
    include EventAttendeeSerializer
    attr_reader :event_attendee

    def init
        set_event
        set_event_attendee
        destroy_event_attendee
    end

    def as_json opts = {}
        {

        }
    end

    private

    def set_event
        @event ||= Event.find(params[:id])
    end

    def set_event_attendee
        @event_attendee = @event.event_attendees.find_by_attendee_id(current_user.id)
    end

    def destroy_event_attendee
        @event_attendee.destroy
    end
end