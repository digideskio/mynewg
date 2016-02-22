# Participant Documentation
#
# == Schema Information
#
# Table name: participants
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  chat_id                  :integer
#  display_messages_from    :datetime
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class Participant < ActiveRecord::Base

    belongs_to :user
    belongs_to :chat

    validates :user_id,                         uniqueness: { scope: :chat_id }

    after_destroy :chat_cleanup,                :if => :chat_exists?

    private

    def chat_cleanup
        chat.destroy if 1 >= chat.participants.count
    end

    def chat_exists?
        chat.nil? ? false : true
    end
end
