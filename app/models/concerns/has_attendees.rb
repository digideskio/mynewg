module HasAttendees
    extend ActiveSupport::Concern

    included do
        has_many :event_attendees
        has_many :attendees,                                            through: :event_attendees, source: :attendee

        has_many :checked_in_event_attendees,                           -> { where(status: 2).where(checked_in: true) }, class_name: 'EventAttendee', foreign_key: 'event_id'
        has_many :checked_in_attendees,                                 through: :checked_in_event_attendees, source: :attendee

        def attending? user
            attendees.include?(user)
        end

        def checked_in? user
            checked_in_attendees.include?(user)
        end

        def can_attend? user
            return false if user.package.blank?
            packages.include?(user.package)
        end

        def maximum_attendees?
            (attendees.member.count == max_attendees) ? true : false
        end
    end
end