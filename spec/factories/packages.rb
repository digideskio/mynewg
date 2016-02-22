FactoryGirl.define do
    factory :package do
        tier { rand(1..3) }
        name { Faker::Lorem.word }
        description { Faker::Lorem.paragraph }
        status { 'draft' }
        chat_status { 'chat_disabled' }

        factory :bronze_package do
            name 'Bronze'
            tier 0
            chat_status { 'chat_disabled' }
        end

        factory :silver_package do
            name 'Silver'
            tier 1
            chat_status { 'chat_enabled' }
        end

        factory :gold_package do
            name 'Gold'
            tier 2
            chat_status { 'chat_enabled' }
        end
    end
end