require Rails.root.join('lib/payatron_4000')

class BillingNotificationsJob < ActiveJob::Base
    queue_as :notifications

    def perform *args
        Payatron4000::intervals
    end
end
