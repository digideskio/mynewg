FactoryGirl.define do
    factory :match do

        factory :event_match do
            category { 'event' }
        end

        factory :like_match do
            category { 'like' }
        end
    end
end