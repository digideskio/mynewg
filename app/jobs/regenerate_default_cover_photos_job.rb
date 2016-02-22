class RegenerateDefaultCoverPhotosJob < ActiveJob::Base
    queue_as :default

    def perform *args
        User.all.each do |user|
            next unless user.cover_photo.file.file.nil?
            user.cover_photo.update!(file: File.open(File.join(Rails.root, "/public/fallback/cover_photo/#{user.gender}/mng-cover-#{user.gender}-#{rand(1..6)}.jpg")))
        end
    end
end
