class DestroyAttachmentInteraction < Interaction
    attr_reader :attachment

    def init
        set_attachment
        destroy_attachment
    end

    def as_json opts = {}
        {

        }
    end

    private

    def set_attachment
        @attachment = current_user.photos.find(params[:id])
    end

    def destroy_attachment
        @attachment.destroy
    end
end