code = RepresentativeCode.create(value: "EVCZ")

# Admin user
admin = User.create(email: 'admin@example.com', name: 'Super Admin', role: 3, password: 'password1', sales_code: code.value, uid: 'admin@example.com', provider: 'email', date_of_birth: Faker::Time.between(50.years.ago, 15.years.ago, :all), location: Faker::Address.city, phone: Faker::PhoneNumber.phone_number, line_id: Faker::Lorem.characters(8))
admin.build_profile_photo(file: File.open(File.join(Rails.root, '/lib/dummy_assets/tom.jpg'))).save!
# Create starter codes for admin

Cms::RepCode.new(user: admin, type: 'B', gender: 'F', count: 8).multiple
Cms::RepCode.new(user: admin, type: 'C', gender: 'F', count: 7).multiple

code.destroy

user = User.create(email: 'demo@mynewgirl.com', name: 'Mike Helm', role: 1, password: 'password1234', sales_code: admin.codes.available.first.value, uid: 'demo@mynewgirl.com', provider: 'email', date_of_birth: Faker::Time.between(50.years.ago, 15.years.ago, :all), location: Faker::Address.city, phone: Faker::PhoneNumber.phone_number, line_id: Faker::Lorem.characters(8))
user.build_profile_photo(file: File.open(File.join(Rails.root, '/lib/dummy_assets/girl.jpg'))).save!

Cms::RepCode.new(user: user, type: 'C', gender: 'M', count: 1).multiple
user.admin!