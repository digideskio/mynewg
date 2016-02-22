require Rails.root.join('lib/eventatron_4000')

class EventRemindersJob < ActiveJob::Base
    queue_as :events

    def perform *args
        Eventatron4000::send_reminders
    end
end
