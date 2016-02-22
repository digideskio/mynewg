class UpdateCoverPhotoJob < ActiveJob::Base
    queue_as :default

    def perform args
        unless args[:users].present?
            args[:users] = User.includes(:cover_photo).where(attachments: { file: nil }).map(&:display_name)
        end
        args[:users].each do |username|
            user = User.find_by_display_name(username)
            user = User.find_by_name(username) if user.nil?
            next if user.nil? || user.profile_photo.nil?
            new_cover_photo = open(user.profile_photo.file.standard.url)
            next if new_cover_photo.nil?
            begin
                user.cover_photo.update!(file: new_cover_photo)
            rescue
                next
            end
        end
    end
end