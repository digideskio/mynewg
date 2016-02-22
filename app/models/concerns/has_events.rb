module HasEvents
    extend ActiveSupport::Concern

    included do
        has_many :attending_event_managements,                                    class_name: 'EventAttendee', foreign_key: 'attendee_id', dependent: :destroy
        has_many :attending_events,                                               through: :attending_event_managements, source: :event

        def events_not_attending
            Event.where.not(id: attending_event_managements.map(&:event_id)).sort_by_day
        end
    end
end
