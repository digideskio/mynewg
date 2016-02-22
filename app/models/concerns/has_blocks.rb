module HasBlocks
    extend ActiveSupport::Concern

    included do
        has_many :user_blocks,                  dependent: :destroy
        has_many :blocks,                       through: :user_blocks, source: :user

        def blocked? user
            self.blocks.include?(user)
        end

        def blocking? user
            self.blocked?(user) || user.blocked?(self)
        rescue
            return false
        end
    end
end