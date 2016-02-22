senior_reps = User.senior_representative
members = User.member
packages = Package.where.not(tier: 0)
prices = PackagePrice.all

junior_rep = senior_reps.first.juniors.first
commission_statuses = ['pending', 'completed', 'cancelled']

5.times do
    prices.first(10).each do |price| 

        sale_transaction = SaleTransaction.create(
                            price: price.value,
                            primary_representative_id: junior_rep.id,
                            member_id: members.sample.id,
                            package_price_id: price.id,
                            payment_type: 'cash'
                        )
        junior_commission = SaleTransactionCommission.create(
                                                        package_price_commission_id: price.commissions.where(role: 0).first.id, 
                                                        sale_transaction_id: sale_transaction.id, 
                                                        representative_id: junior_rep.id, 
                                                        payment_type: 'cash'
                                            )
        junior_commission.update_column(:status, commission_statuses.sample)
        senior_commission = SaleTransactionCommission.create(
                                                        package_price_commission_id: price.commissions.where(role: 1).first.id, 
                                                        sale_transaction_id: sale_transaction.id, 
                                                        representative_id: junior_rep.senior.id, 
                                                        payment_type: 'cash'
                                            )
        senior_commission.update_column(:status, commission_statuses.sample)
    end
end