module HasPhotos
    extend ActiveSupport::Concern

    included do
        has_many :photos,                   class_name: 'Attachment', foreign_key: 'attachable_id'
        has_one :profile_photo,             -> { where(attachable_type: 'ProfilePhoto') }, class_name: 'Attachment', foreign_key: 'attachable_id', dependent: :destroy
        has_one :cover_photo,               -> { where(attachable_type: 'CoverPhoto') }, class_name: 'Attachment', foreign_key: 'attachable_id'
        has_many :gallery_photos,           -> { where(attachable_type: 'GalleryPhoto') }, class_name: 'Attachment', foreign_key: 'attachable_id', dependent: :destroy

        after_create :build_a_profile_photo
        after_create :build_a_cover_photo

        accepts_nested_attributes_for :profile_photo, allow_destroy: true
        accepts_nested_attributes_for :cover_photo
        accepts_nested_attributes_for :gallery_photos, allow_destroy: true
    end

    private

    def build_a_profile_photo
        build_profile_photo.save(validate: false)
    end

    def build_a_cover_photo
        build_cover_photo.save(validate: false)
    end
end

