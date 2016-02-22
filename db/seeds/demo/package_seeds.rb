description = '<li>Professional matchmaker services</li>
<li>Get invited to private BRONZE events and parties</li>
<li>Chat with BRONZE members and belows</li>
<li>Get professional portrait and video interview</li>
<li>Get BRONZE portfolio</li>'

package = Package.create(name: 'Bronze', tier: 0, description: description)

PackagePrice.create(gender: 'female', value: 10, interval: 0, package_id: package.id)
PackagePrice.create(gender: 'male', value: 40, interval: 0, package_id: package.id)
PackagePrice.create(gender: 'female', value: 15, interval: 30, package_id: package.id)
PackagePrice.create(gender: 'male', value: 35, interval: 30, package_id: package.id)

package.published!

package_2 = Package.create(name: 'Silver', tier: 1, description: description)

PackagePrice.create(gender: 'female', value: 300, interval: 0, package_id: package_2.id)
PackagePrice.create(gender: 'male', value: 1000, interval: 0, package_id: package_2.id)
PackagePrice.create(gender: 'female', value: 150, interval: 30, package_id: package_2.id)
PackagePrice.create(gender: 'male', value: 500, interval: 30, package_id: package_2.id)

package_2.published!

package_3 = Package.create(name: 'Gold', tier: 2, description: description)

PackagePrice.create(gender: 'female', value: 600, interval: 0, package_id: package_3.id)
PackagePrice.create(gender: 'male', value: 3000, interval: 0, package_id: package_3.id)
PackagePrice.create(gender: 'female', value: 300, interval: 30, package_id: package_3.id)
PackagePrice.create(gender: 'male', value: 1500, interval: 30, package_id: package_3.id)

package_3.published!

reps = ['junior_representative', 'senior_representative']
prices = PackagePrice.all

prices.each do |price|
    PackagePriceCommission.create(role: 'junior_representative', value: Faker::Number.number(3), package_price_id: price.id)
    PackagePriceCommission.create(role: 'senior_representative', value: Faker::Number.number(3), package_price_id: price.id)
end


