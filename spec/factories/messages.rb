FactoryGirl.define do
    factory :message do
        text { Faker::Lorem.word }
        state { 'read' }

        factory :unread_message do
            state { 'unread' }
        end
    end
end
