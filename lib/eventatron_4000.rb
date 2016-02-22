module Eventatron4000

    class << self

        def send_reminders
            Event.has_attendees.future_events.each do |event|
                next unless event.reminder_event?
                event.attendees.each do |user|
                    EventMailer.reminder(user, event).deliver_later
                end
            end
        end

        def create_matches
            Event.unmatched.has_attendees.past_events.each do |event|
                next unless event.match_event?

                event.attendees.combination(2).each do |(attendee_1, attendee_2)|
                    attendee_1.event_match_managements.create(match: attendee_2) unless attendee_1.blocking?(attendee_2)
                end

                event.update_column(:matched, true)
                event.active_invite_notifications.update_all(status: 1)
            end
        end
    end
end
