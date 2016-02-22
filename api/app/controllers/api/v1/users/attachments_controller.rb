class Api::V1::Users::AttachmentsController < Api::ApplicationController

    def index
        respond_with_interaction GalleryAttachmentsLoadingInteraction
    end
end