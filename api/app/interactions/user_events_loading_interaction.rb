class UserEventsLoadingInteraction < Interaction
    include EventSerializer
    attr_reader :events

    def init
        set_user
        set_events
    end

    def as_json opts = {}
        {
            events: events.map { |e| serialize_event(e) }
        }
    end

    private

    def set_user
        @user ||= User.find(params[:user_id])
    end

    def set_events
        @events ||= @user.attending_events.attendable
    end
end
