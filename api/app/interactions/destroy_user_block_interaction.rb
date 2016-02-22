class DestroyUserBlockInteraction < Interaction
    attr_reader :user_block

    def init
        set_user_block
        destroy_user_block
    end

    def as_json opts = {}
        {

        }
    end

    private

    def set_user_block
        @user_block = current_user.user_blocks.find_by_blocked_id(params[:id])
    end

    def destroy_user_block
        @user_block.destroy
    end
end