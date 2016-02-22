code = RepresentativeCode.create(value: "EVCZ")

# Admin user
admin = User.create(email: 'admin@mynewg.com', name: 'Mike Helm', role: 3, password: 'password1', sales_code: code.value, uid: 'admin@mynewg.com', provider: 'email', date_of_birth: Faker::Time.between(50.years.ago, 15.years.ago, :all), location: 'Chiang Mai', phone: '0932755734')
admin.profile_photo.update(file: File.open(File.join(Rails.root, '/lib/dummy_assets/tom.jpg')))

# Jasmine User
jasmine = User.create(username: 'jasmine-helm', email: 'jasmine@mynewg.com', name: 'Jasmine Helm', role: 2, password: 'password1', sales_code: code.value, uid: 'jasmine@mynewg.com', provider: 'email', date_of_birth: Faker::Time.between(50.years.ago, 15.years.ago, :all), location: 'Chiang Mai', phone: '0925600082')
jasmine.profile_photo.update(file: File.open(File.join(Rails.root, '/lib/dummy_assets/girl.jpg')))
