FactoryGirl.define do
  factory :representative_code do
    status { :available }
    value { "#{Faker::Lorem.characters(4)}FB" }

    factory :used_representative_code do
      status { :used }
    end
  end
end