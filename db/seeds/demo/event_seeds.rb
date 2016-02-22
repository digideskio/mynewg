5.times do
    event = Event.new(name: Faker::Lorem.characters(5), location: Faker::Address.city, description: Faker::Lorem.paragraph(2), start_date: Faker::Time.between(2.days.ago, Time.now, :afternoon), end_date: Faker::Time.between(2.days.ago, Time.now, :evening) )
    event.build_hero_photo(file: File.open(File.join(Rails.root, '/lib/dummy_assets/warm-up-cafe.jpg')))
    event.save!
end