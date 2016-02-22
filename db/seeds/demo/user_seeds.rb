admin = User.admin.first
packages = Package.all

2.times do
    email = Faker::Internet.email
    user = User.create(email: email, name: Faker::Name.name, role: 1, password: 'password123', sales_code: admin.codes.available.first.value, uid: email, provider: 'email', date_of_birth: Faker::Time.between(50.years.ago, 15.years.ago, :all), location: Faker::Address.city, phone: Faker::PhoneNumber.phone_number, line_id: Faker::Lorem.characters(8))
    user.build_profile_photo(file: File.open(File.join(Rails.root, '/lib/dummy_assets/girl.jpg'))).save!
    Cms::RepCode.new(user: user, type: 'C', gender: 'F', count: 1).multiple
end

3.times do
    email = Faker::Internet.email
    user = User.create(email: email, name: Faker::Name.name, role: 2, password: 'password123', sales_code: admin.codes.available.first.value, uid: email, provider: 'email', date_of_birth: Faker::Time.between(50.years.ago, 15.years.ago, :all), location: Faker::Address.city, phone: Faker::PhoneNumber.phone_number, line_id: Faker::Lorem.characters(8))
    user.build_profile_photo(file: File.open(File.join(Rails.root, '/lib/dummy_assets/girl.jpg'))).save!
    Cms::RepCode.new(user: user, type: 'B', gender: 'M', count: 1).multiple
end

User.senior_representative.each do |senior|
    email = Faker::Internet.email
    junior = User.create(email: email, name: Faker::Name.name, role: 1, password: 'password123', sales_code: admin.codes.available.first.value, uid: email, provider: 'email', date_of_birth: Faker::Time.between(50.years.ago, 15.years.ago, :all), location: Faker::Address.city, phone: Faker::PhoneNumber.phone_number, line_id: Faker::Lorem.characters(8))
    junior.build_profile_photo(file: File.open(File.join(Rails.root, '/lib/dummy_assets/girl.jpg'))).save!
    Cms::RepCode.new(user: junior, type: 'C', gender: 'F', count: 1).multiple
    UserManager.create(junior_id: junior.id, senior_id: senior.id)
end

(User.junior_representative + User.senior_representative).each do |rep|
    email = Faker::Internet.email
    user = User.create(email: email, name: Faker::Name.name, role: 0, password: 'password123', sales_code: rep.codes.available.first.value, uid: email, provider: 'email', package_id: packages.sample.id, date_of_birth: Faker::Time.between(50.years.ago, 15.years.ago, :all), location: Faker::Address.city, phone: Faker::PhoneNumber.phone_number, line_id: Faker::Lorem.characters(8))
    user.build_profile_photo(file: File.open(File.join(Rails.root, '/lib/dummy_assets/girl.jpg'))).save!
end