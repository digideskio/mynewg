require Rails.root.join('lib/cms')
class ArchiveNotificationsJob < ActiveJob::Base
    queue_as :notifications

    def perform *args
        Cms::archive_notifications
    end
end
