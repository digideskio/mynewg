admin = User.admin.first

3.times do |i|
    email = "senior#{i}@mynewgirl.com"
    user = User.create(email: email, name: Faker::Name.name, role: 2, password: 'password1', sales_code: admin.codes.available.first.value, uid: email, provider: 'email', date_of_birth: Faker::Time.between(50.years.ago, 15.years.ago, :all), location: Faker::Address.city, phone: Faker::PhoneNumber.phone_number, line_id: Faker::Lorem.characters(8))
    user.build_profile_photo(file: File.open(File.join(Rails.root, '/lib/dummy_assets/girl.jpg'))).save!
    sequence_id = RepresentativeCode.all.count.next
    Cms::RepCode.new(user: user, type: 'C', gender: 'F', sequence_id: sequence_id).single
end

User.senior_representative.each_with_index do |senior, index|
    email = "junior#{index}@mynewgirl.com"
    junior = User.create(email: email, name: Faker::Name.name, role: 1, password: 'password1', sales_code: admin.codes.available.first.value, uid: email, provider: 'email', date_of_birth: Faker::Time.between(50.years.ago, 15.years.ago, :all), location: Faker::Address.city, phone: Faker::PhoneNumber.phone_number, line_id: Faker::Lorem.characters(8))
    junior.build_profile_photo(file: File.open(File.join(Rails.root, '/lib/dummy_assets/girl.jpg'))).save!
    sequence_id = RepresentativeCode.all.count.next
    Cms::RepCode.new(user: junior, type: 'B', gender: 'F', sequence_id: sequence_id).single
    UserManager.create(junior_id: junior.id, senior_id: senior.id)
end