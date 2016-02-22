class CreateGalleryAttachmentInteraction < Interaction
    include AttachmentSerializer
    include Base64Attachable
    attr_reader :attachment

    def init
        create_attachment
    end

    def as_json opts = {}
        {
            attachment: serialize_attachment(attachment)
        }
    end

    private

    def create_attachment
        @attachment = current_user.gallery_photos.create!(attachment_params)
    ensure
        clean_tempfile
    end
end