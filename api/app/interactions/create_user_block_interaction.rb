class CreateUserBlockInteraction < Interaction
    include UserBlockSerializer
    attr_reader :user_block

    def init
        create_user_block
    end

    def as_json opts = {}
        {
            user_block: serialize_user_block(user_block)
        }
    end

    private

    def create_user_block
        @user_block = current_user.user_blocks.create(user_block_params)
        raise ActiveRecord::RecordInvalid.new(@user_block) unless @user_block.valid?
    end

    def user_block_params
        params.require(:user_block).permit(:blocked_id)
    end
end