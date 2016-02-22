FactoryGirl.define do
  factory :event do
    name { Faker::Name.name }
    location { Faker::Address.street_address }
    description { Faker::Lorem.sentence }
    start_date { Faker::Time.forward(30, :all) }
    end_date { start_date + 1.day }
    
    association :hero_photo, factory: :event_hero_attachment
  end
end
