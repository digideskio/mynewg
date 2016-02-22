# Like Documentation
#
# == Schema Information
#
# Table name: likes
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  like_id                  :integer       
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class Like < ActiveRecord::Base

    belongs_to :user
    belongs_to :like,                                  class_name: 'User'

    validates :user_id, :like_id,                       presence: true
    validates :like_id,                                 uniqueness: { scope: :user_id }

    validate :duplication,                              on: :create

    after_create :notification

    def duplication
        unless Like.where('user_id = :user_id AND like_id = :like_id OR user_id = :like_id AND like_id = :user_id ', user_id: self.user_id, like_id: self.like_id).empty?
            errors.add(:like, " relation already exists between these users.")
        end
    end

    def notification
        like.like_notifications.create(source_id: user.id)
    end
end
