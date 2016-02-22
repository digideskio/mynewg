require 'payatron_4000/omiser'
require 'payatron_4000/casher'

module Payatron4000

    class << self

        def intervals
            BillingNotification.active.each do |notification|
                if notification.billing_date.today?
                    if notification.user.paid_by_cash == true
                        charge_user(notification, 'cash')
                        if @charge.authorized
                            successful_payment(notification)
                        else
                            failed_payment(notification)
                        end
                    else
                        charge_user(notification, 'omise')
                        if @charge.authorized
                            successful_payment(notification)
                        else
                            failed_payment(notification)
                        end
                    end
                end

                if (notification.billing_date == (Date.today + 1.week)) && (notification.user.cash_amount < n.package_price.value)
                    MemberMailer.cash_payment_reminder(notification.user).deliver_later
                end
            end
        end

        def calculate_price user, price, discount_code, price_type
            Cms::Discounter.new(user: user, price: price.value, discount_code: discount_code, price_type: price_type).price
        end

        def create_single_billing_notifications user, package_price
            package_price.package.gender_prices(user).each do |price|
                next unless price.interval?
                user.billing_notifications.active.update_all(status: 3)
                user.billing_notifications.build(package_price_id: price.id, billing_date: Date.today + price.interval).save!
            end
        end

        def create_sale_transaction price, calculated_price, user, discount_code, payment_type, charge
            SaleTransaction.create(
                price: calculated_price,
                member_id: user.id,
                primary_representative_id: user.representative.try(:id),
                package_price_id: price.id,
                omise_charge_id: charge.id.nil? ? nil : charge.id,
                payment_type: payment_type,
                status: 'completed',
                discount_code: discount_code
            )
        end

        def create_sale_commissions sale_transaction, price, payment_type
            sale_transaction.all_representatives.each do |rep|
                commission_id = set_package_commission_id(rep.role, price)
                next if commission_id.nil?
                SaleTransactionCommission.create(
                    payment_type: payment_type,
                    sale_transaction_id: sale_transaction.id,
                    package_price_commission_id: commission_id.id,
                    representative_id: rep.id
                )
            end
        end
        
        private

        def successful_payment notification
            notification.archived!
            unless notification.last_for_package?
                notification.user.billing_notifications.build(package_price_id: notification.package_price.id, billing_date: Date.today + notification.package_price.interval).save!
            end
        end

        def failed_payment notification
            MemberMailer.failed_recurring_payment(notification).deliver_later
            AdminMailer.failed_recurring_payment(notification).deliver_later
            notification.user.limited!
            notification.failed!
        end

        def set_package_commission_id role, price
            price.commissions.where(role: Cms::set_role_id(role)).first
        end

        def charge_user notification, payment_type
            Cms::PayProvider.new(user: notification.user, price: notification.package_price, provider: payment_type, discount_code: notification.user.recurring_discount_code).recurring
        end
    end
end