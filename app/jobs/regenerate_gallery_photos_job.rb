class RegenerateGalleryPhotosJob < ActiveJob::Base
    queue_as :default

    def perform *args
        User.all.each do |u|
            u.gallery_photos.each do |gf|
                next if gf.file.blank?
                gf.file.recreate_versions!(:thumb, :square, :standard, :cover)
                gf.save!
            end
        end
    end
end
