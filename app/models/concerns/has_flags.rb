module HasFlags
    extend ActiveSupport::Concern

    included do
        has_many :user_flags,                          dependent: :destroy
        has_many :flagged_users,                       through: :user_flags, source: :flagged_user

        def flagged? user
            flagged_users.include?(user)
        end
    end
end