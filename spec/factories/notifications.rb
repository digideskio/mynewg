FactoryGirl.define do
    factory :notification do
        state { 'read' }
        status { 'active' }

        factory :invite_notification do
            category { 'invite' }
        end

        factory :attending_notification do
            category { 'attending' }
        end

        factory :match_notification do
            category { 'match' }
        end
    end
end
