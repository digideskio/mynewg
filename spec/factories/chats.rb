FactoryGirl.define do
  factory :chat do

    factory :chat_with_five_messages do
        after(:create) do |chat, evaluator|
            create_list(:message, 5, chat: chat)
        end
    end
  end
end
