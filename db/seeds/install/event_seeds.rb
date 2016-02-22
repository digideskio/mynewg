event = Event.new(name: 'Photo Shoot - Take 1', location: 'Royal Park Rajapruek', description: 'Come join us at the park for a day of relaxation and fun. A professional photographer will be on hand to create beautiful pictures to enhance your profile.', start_date: Faker::Time.between(2.days.ago, Time.now, :afternoon), end_date: Faker::Time.between(2.days.ago, Time.now, :evening) )
    event.build_hero_photo(file: File.open(File.join(Rails.root, '/lib/dummy_assets/photo_shoot.jpg')))
    event.save(validate: false)

event2 = Event.new(name: 'Photo Shoot - Take 2', location: 'Royal Park Rajapruek', description: 'Come join us at the park for a day of relaxation and fun. A professional photographer will be on hand to create beautiful pictures to enhance your profile.', start_date: Faker::Time.between(2.days.ago, Time.now, :afternoon), end_date: Faker::Time.between(2.days.ago, Time.now, :evening) )
    event.build_hero_photo(file: File.open(File.join(Rails.root, '/lib/dummy_assets/photo_shoot.jpg')))
    event.save(validate: false)

event3 = Event.new(name: 'Cooking Class', location: 'Thai Farm Cooking School', description: 'Escape from the bustling city for a day. Come learn how to prepare and cook a Thai meal while enjoying the relaxing, non-touristy countryside. On the way to the farm we will stop at a local market for a brief tour. The cooking school is approximately 17 kms from Chiang Mai city. Upon arrival we will take you around the organic farm.  You will be able to see many different kinds of organic herbs, vegetables and fruits that the school proudly grows themselves. You will be given the opportunity to pick some of the fresh ingredients that you will use while preparing your favorite dishes in one of the spacious, well-equipped kitchens. Each person will have his/her own cooking station. Finally, enjoy eating your meal on the terrace overlooking the fishpond where you will have a splendid view of the entire farm as well as the lush nearby mountains.', start_date: Faker::Time.between(2.days.ago, Time.now, :afternoon), end_date: Faker::Time.between(2.days.ago, Time.now, :evening) )
    event.build_hero_photo(file: File.open(File.join(Rails.root, '/lib/dummy_assets/cooking.jpg')))
    event.save(validate: false)

event4 = Event.new(name: 'Salsa Night', location: 'Warmup Cafe', description: 'Get your dance shoes ready and join us for our monthly salsa party at the Warmup Cafe, including salsa lessons, a heavy snack buffet, and dancing until 1am in the morning to the music of our exclusive DJ.', start_date: Faker::Time.between(2.days.ago, Time.now, :afternoon), end_date: Faker::Time.between(2.days.ago, Time.now, :evening) )
    event.build_hero_photo(file: File.open(File.join(Rails.root, '/lib/dummy_assets/warm-up-cafe.jpg')))
    event.save(validate: false)

event4 = Event.new(name: 'Mixer Night', location: 'Blar Blar Bar', description: 'Come out and meet other members at our weekly mixer party at Blar Blar Bar, a big and boozy beer garden popular with uni students and other youthful punters.', start_date: Faker::Time.between(2.days.ago, Time.now, :afternoon), end_date: Faker::Time.between(2.days.ago, Time.now, :evening) )
    event.build_hero_photo(file: File.open(File.join(Rails.root, '/lib/dummy_assets/blarblarbar.jpg')))
    event.save(validate: false)