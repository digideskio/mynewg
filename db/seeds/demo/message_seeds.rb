users = User.member

users.each do |user|
    3.times do 
        other_user = User.member.where.not(id: user.id).sample
        chat = Chat.create
        user.participants.build(chat_id: chat.id).save!
        other_user.participants.build(chat_id: chat.id).save!
        5.times do
            time = Faker::Time.between(2.days.ago, Time.now, :all)
            user.messages.build(text: Faker::Lorem.characters(5), chat_id: chat.id, created_at: time, updated_at: time).save!
        end
        5.times do
            time = Faker::Time.between(2.days.ago, Time.now, :all)
            other_user.messages.build(text: Faker::Lorem.characters(5), chat_id: chat.id, created_at: time, updated_at: time).save!
        end
    end
end

