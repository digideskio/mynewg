class Api::V1::AttachmentsController < Api::ApplicationController

    def create
        respond_with_interaction CreateGalleryAttachmentInteraction
    end

    def update
        respond_with_interaction UpdateAttachmentInteraction
    end

    def avatar
        respond_with_interaction UpdateProfilePhotoInteraction
    end

    def set_avatar
        respond_with_interaction SetAvatarInteraction
    end

    def cover
        respond_with_interaction UpdateCoverAttachmentInteraction
    end

    def destroy
        respond_with_interaction DestroyAttachmentInteraction
    end
end
