# Message Documentation
#
# == Schema Information
#
# Table name: messages
#
#  id                       :integer          not null, primary key
#  text                     :string(255)
#  state                    :integer
#  user_id                  :integer
#  chat_id                  :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class Message < ActiveRecord::Base

    belongs_to :user
    belongs_to :chat

    validates :text, :user_id, :chat_id,                    presence: true

    default_scope { order(created_at: :desc) }

    enum state: [:unread, :read]

    def self? user
        self.user == user
    end

    def next
        self.class.unscoped.where("created_at >= ? AND id != ? AND chat_id = ?", created_at, id, chat_id).order('created_at DESC').last
    end
end
