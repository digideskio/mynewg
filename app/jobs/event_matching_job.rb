require Rails.root.join('lib/eventatron_4000')

class EventMatchingJob < ActiveJob::Base
    queue_as :events

    def perform *args
        Eventatron4000::create_matches
    end
end
