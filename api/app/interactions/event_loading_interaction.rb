class EventLoadingInteraction < Interaction
    include EventSerializer
    attr_reader :event

    def init
        set_event
    end

    def as_json opts = {}
        {
            event: serialize_event(event)
        }
    end

    private

    def set_event
        @event ||= Event.includes(:attendees).find(params[:id])
    end
end