class EventAttendeesLoadingInteraction < Interaction
    include AttendeeSerializer
    attr_reader :attendees

    def init
        set_event
        set_attendees
    end

    def as_json opts = {}
        {
            attendees: attendees.map { |a| serialize_attendee(a) }
        }
    end

    private

    def set_event
        @event ||= Event.find(params[:id])
    end

    def set_attendees
        @attendees ||= @event.attendees
    end
end