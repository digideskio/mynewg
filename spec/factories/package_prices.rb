FactoryGirl.define do
    factory :package_price do
        gender { 'male' }
        value { Faker::Number.decimal(2) }

        association :package

        factory :single_package_price do
            interval { 0 }
        end

        factory :recurring_package_price do
            interval ( 30 )
        end
    end
end