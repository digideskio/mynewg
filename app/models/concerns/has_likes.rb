module HasLikes
    extend ActiveSupport::Concern

    included do

        has_many :like_managements,                             class_name: 'Like', dependent: :destroy
        has_many :likes,                                        through: :like_managements
        has_many :inverse_like_managements,                     class_name: 'Like', foreign_key: 'like_id', dependent: :destroy
        has_many :inverse_likes,                                through: :inverse_like_managements, source: :user

        def all_like_managements
            (like_managements + inverse_like_managements).uniq
        end

        def all_likes
            (likes + inverse_likes).uniq
        end

        def like? user
            likes.include?(user)
        end

        def like_me? user
            inverse_likes.include?(user)
        end

        def like_initiator user
            Like.where(id: all_like_managements.map(&:id)).where('like_id = :current_user_id AND user_id = :user_id OR like_id = :user_id AND user_id = :current_user_id', current_user_id: self.id, user_id: user.id).first.try(:user_id)
        end

        def current_like user_id
            Like.where(id: all_like_managements.map(&:id)).where('like_id = :user_id OR user_id = :user_id', user_id: user_id).first
        end
    end
end