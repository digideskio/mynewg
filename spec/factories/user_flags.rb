FactoryGirl.define do
    factory :user_flag do
        reason { 'spam_messages' }
        additional_info { 'More info about my flag' }
    end
end