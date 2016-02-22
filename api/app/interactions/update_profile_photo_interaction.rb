class UpdateProfilePhotoInteraction < Interaction
    include AttachmentSerializer
    include Base64Attachable
    attr_reader :attachment

    def init
        set_attachment
        update_attachment
    end

    def as_json opts = {}
        {
            attachment: serialize_attachment(attachment)
        }
    end

    private

    def set_attachment
        @attachment ||= current_user.profile_photo
    end
end