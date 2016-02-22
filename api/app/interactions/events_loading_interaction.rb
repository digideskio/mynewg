class EventsLoadingInteraction < Interaction
    include EventSerializer
    attr_reader :events

    def init
        set_events
    end

    def as_json opts = {}
        {
            events: events.map { |e| serialize_event(e) }
        }
    end

    private

    def set_events
        @events ||= Event.attendable.includes(:attendees)
    end
end
