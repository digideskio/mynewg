descriptionSilver = '<li>Professional matchmaker services</li>
<li>Get invited to private Silver events and parties</li>
<li>Chat with Silver members and below</li>
<li>Get professional portrait and video interview</li>
<li>Get Silver portfolio</li>'

descriptionGold = '<li>Professional matchmaker services</li>
<li>Get invited to private Gold events and parties</li>
<li>Chat with Gold members and belows</li>
<li>Get professional portrait and video interview</li>
<li>Get Gold portfolio</li>'

package = Package.create(name: 'Silver', tier: 1, description: descriptionSilver)

PackagePrice.create(gender: 'female', value: 300, interval: 0, package_id: package.id)
PackagePrice.create(gender: 'male', value: 1500, interval: 0, package_id: package.id)
PackagePrice.create(gender: 'female', value: 0, interval: 30, package_id: package.id)
PackagePrice.create(gender: 'male', value: 500, interval: 30, package_id: package.id)

PackagePriceCommission.create(role: 'junior_representative', value: 100, package_price_id: 1)
PackagePriceCommission.create(role: 'senior_representative', value: 100, package_price_id: 1)
PackagePriceCommission.create(role: 'junior_representative', value: 300, package_price_id: 2)
PackagePriceCommission.create(role: 'senior_representative', value: 300, package_price_id: 2)
PackagePriceCommission.create(role: 'junior_representative', value: 0, package_price_id: 3)
PackagePriceCommission.create(role: 'senior_representative', value: 0, package_price_id: 3)
PackagePriceCommission.create(role: 'junior_representative', value: 150, package_price_id: 4)
PackagePriceCommission.create(role: 'senior_representative', value: 0, package_price_id: 4)

package.published!

package_2 = Package.create(name: 'Gold', tier: 2, description: descriptionGold)

PackagePrice.create(gender: 'female', value: 0, interval: 0, package_id: package_2.id)
PackagePrice.create(gender: 'male', value: 3000, interval: 0, package_id: package_2.id)
PackagePrice.create(gender: 'female', value: 0, interval: 30, package_id: package_2.id)
PackagePrice.create(gender: 'male', value: 1000, interval: 30, package_id: package_2.id)

PackagePriceCommission.create(role: 'junior_representative', value: 200, package_price_id: 1)
PackagePriceCommission.create(role: 'senior_representative', value: 200, package_price_id: 1)
PackagePriceCommission.create(role: 'junior_representative', value: 600, package_price_id: 2)
PackagePriceCommission.create(role: 'senior_representative', value: 600, package_price_id: 2)
PackagePriceCommission.create(role: 'junior_representative', value: 0, package_price_id: 3)
PackagePriceCommission.create(role: 'senior_representative', value: 0, package_price_id: 3)
PackagePriceCommission.create(role: 'junior_representative', value: 300, package_price_id: 4)
PackagePriceCommission.create(role: 'senior_representative', value: 0, package_price_id: 4)

package_2.published!

