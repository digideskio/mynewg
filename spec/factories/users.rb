FactoryGirl.define do
    factory :user do
        email { Faker::Internet.email }
        name { Faker::Name.name }
        gender { 'male' }
        sales_code { Faker::Lorem.characters(5) }
        username { "#{name.parameterize}" }
        omise_id { Faker::Lorem.characters(10) }
        status { 'active' }
        provider { 'email' }
        uid { "#{email}" }
        date_of_birth { Faker::Time.between(50.years.ago, 18.years.ago, :all) }
        location { Faker::Address.country }
        phone { Faker::PhoneNumber.phone_number }
        line_id { "#{name.parameterize}" }
        biography { Faker::Lorem.characters(130) }
        drink { 'drink_socially' }
        smoke { 'smoke_socially' }
        english { 'en_good' }
        thai { 'th_good' }
        platinum { false }
        height { Faker::Number.number(2) }
        kids { false }
        display_name { Faker::Name.name }
        locale { 'en_US' }
        password { Faker::Lorem.characters(8) }
        password_confirmation { "#{password}" }

        factory :with_sales_code do
          after(:build) { |user| user.sales_code = create(:representative_code).value }

          factory :member do
                role { 'member' }

                factory :female_member do
                    gender { 'female' }
                end
          end

          factory :lead do
              role { 'lead' }
          end

          factory :limited do
              role { 'limited' }
          end
        end

        factory :junior_rep do
            role { 'junior_representative' }
        end

        factory :senior_rep do
            role { 'senior_representative' }
        end

        factory :admin do
            role { 'admin' }
        end

        factory :platinum do
            role { 'junior_representative' }
            platinum { true }
        end

        factory :invalid_user do
            email { nil }
        end
    end
end