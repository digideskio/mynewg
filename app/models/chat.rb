# Chat Documentation
#
# == Schema Information
#
# Table name: chats
#
#  id                       :integer          not null, primary key
#  subject                  :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class Chat < ActiveRecord::Base
    include HasMessages

    has_many :messages,                     dependent: :destroy
    has_many :participants,                 dependent: :destroy
    has_many :users,                        through: :participants

    accepts_nested_attributes_for :participants

    scope :order_by_messages,               -> { includes(:messages).order('messages.created_at DESC') }

    validate :uniq_participants


    def other_user user
        users.where.not(users: { id: user.id }).take
    end    

    def current_participant current_user_id
        participants.where(user_id: current_user_id).take
    end

    private

    def uniq_participants
        return if participants.size < 2

        already_exist = Chat.joins(:participants).where(participants: { user_id: participants.map(&:user_id) }).group(:id).having('count(chats.id) > 1').first.present?

        errors.add(:participants, 'A chat with these participants already exists.') if already_exist
    end
end
