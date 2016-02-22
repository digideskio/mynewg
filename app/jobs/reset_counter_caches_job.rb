require Rails.root.join('lib/cms')

class ResetCounterCacheJob < ActiveJob::Base
    queue_as :default

    def perform *args
        Cms::reset_counter_caches(Event.future_events, :attendees)
        Cms::reset_counter_caches(User.all, :attending_events)
    end
end
