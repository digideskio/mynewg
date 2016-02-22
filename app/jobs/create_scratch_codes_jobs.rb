require Rails.root.join('lib/eventatron_4000')

class CreateScratchCodesJob < ActiveJob::Base
    queue_as :default

    def perform *args
        Cms::ScratchCode.new(count: 500).multiple
    end
end
