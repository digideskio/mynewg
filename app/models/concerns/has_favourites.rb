module HasFavourites
    extend ActiveSupport::Concern

    included do
        has_many :user_favourites,                           dependent: :destroy
        has_many :favourites,                                through: :user_favourites

        def favourite? user
            favourites.include?(user)
        end

        def favourite_id user
            user_favourites.where(favourite_id: user.id).first.try(:id)
        end
    end
end