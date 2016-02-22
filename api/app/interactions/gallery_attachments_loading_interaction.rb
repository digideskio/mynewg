class GalleryAttachmentsLoadingInteraction < Interaction
    include AttachmentSerializer
    attr_reader :attachments

    def init
        set_user
        @attachments = @user.gallery_photos
    end

    def as_json(opts = {})
        {
            images: attachments.map { |a| serialize_attachment(a) }
        }
    end

    private

    def set_user
        @user = User.find(params[:user_id])
    end
end
