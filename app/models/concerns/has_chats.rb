module HasChats
    extend ActiveSupport::Concern

    included do
        has_many :messages,                 dependent: :destroy
        has_many :participants,             dependent: :destroy
        has_many :chats,                    through: :participants

        after_create :create_welcome_chats

        def can_chat? user
            (self.admin_present?(user) || self.platinum_present?(user) || self.female? || self.representative_link?(user) || chat_enabled_package?) && !self.blocking?(user)
        end

        def current_chat user
            Chat.includes(:participants).where(id: chats.pluck(:id)).where(participants: { user_id: user.id} ).first.try(:id)
        end

        def begin_chat id
            create_chat_with_messages(
                id,
                'This is very beginning of this chat'
            )
        end
    end

    private  

    def chat_enabled_package?
        package.nil? ? false : package.chat_enabled? ? true : false
    end

    def create_welcome_chats
        jasmine = User.where(username: 'jasmine-helm').first

        if jasmine.present?
            create_chat_with_messages(
                jasmine.id,
                'Hey guys, welcome to MyNewG. If you have any serious issues or problems, please contact me here. - Jasmine (company founder)',
                'เฮ้พวกยินดีต้อนรับเข้าสู่ MyNewG หากคุณมีปัญหาใดๆ สามารถติดต่อเราได้ที่นี่ - จัสมิน (ผู้ก่อตั้ง บริษัท)'
            )
        end

        if representative.present? && jasmine != representative
            create_chat_with_messages(
                representative.id,
                "Hey! Welcome to MyNewG, we’re very excited to have you. If you have any questions or comments, please contact me here. - #{representative.name}",
                "Hey! ยินดีต้อนรับเข้าสู่ MyNewG เรารู้สึกตื่นเต้นมากที่คุณเข้าร่วมกับเรา หากคุณมีคำถามหรือความคิดเห็นใดโปรดติดต่อเราได้ที่นี่ - #{representative.name}"
            )
        end
    end

    def create_chat_with_messages sender_id, *message_texts
        chat = Chat.create!(participants_attributes: [
            { user_id: id },
            { user_id: sender_id }
        ])

        message_texts.each do |message_text|
            Message.create!(chat_id: chat.id,
                            text: message_text,
                            user_id: sender_id)
        end
    end
end
