# Match Documentation
#
# == Schema Information
#
# Table name: matches
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  match_id                 :integer       
#  status                   :integer          default(0)   
#  category                 :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class Match < ActiveRecord::Base

    belongs_to :user
    belongs_to :match,                                      class_name: 'User'

    validates :user_id, :match_id, :category,               presence: true

    validate :duplication,                                  on: :create

    after_create :notification

    enum status: [:active, :archived]
    enum category: [:event, :like]

    def duplication
        unless Match.where('user_id = :user_id AND match_id = :match_id OR user_id = :match_id AND match_id = :user_id AND status = :status', user_id: self.user_id, match_id: self.match_id, status: 0).empty?
            errors.add(:match, " relation already exists between these users.")
        end
    end

    def notification
        user.match_notifications.create(source_id: match.id)
        match.match_notifications.create(source_id: user.id)
    end
end
