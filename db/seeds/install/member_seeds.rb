packages = Package.all

(User.junior_representative + User.senior_representative).each_with_index do |rep, index|
    email = "member#{index}@mynewgirl.com"
    user = User.create(email: email, name: Faker::Name.name, role: 0, password: 'password1', sales_code: rep.codes.available.first.value, uid: email, provider: 'email', date_of_birth: Faker::Time.between(50.years.ago, 15.years.ago, :all), package_id: packages.sample.id, location: Faker::Address.city, phone: Faker::PhoneNumber.phone_number, line_id: Faker::Lorem.characters(8))
    user.build_profile_photo(file: File.open(File.join(Rails.root, '/lib/dummy_assets/girl.jpg'))).save!
end