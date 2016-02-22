module HasNotifications
    extend ActiveSupport::Concern

    included do
        has_many :notifications,                                        dependent: :destroy
        has_many :like_notifications,                                   -> { where(category: 0) }, class_name: 'Notification'
        has_many :invite_notifications,                                 -> { where(category: 1) }, class_name: 'Notification'
        has_many :match_notifications,                                  -> { where(category: 2) }, class_name: 'Notification'
        has_many :attending_notifications,                              -> { where(category: 3) }, class_name: 'Notification'
        has_many :active_sent_notifications,                            -> { where(status: 0) }, class_name: 'Notification', foreign_key: 'source_id', dependent: :destroy

        has_many :billing_notifications,                                dependent: :destroy

        def reset_billing_notifications
            unless package_id.nil?
                package.gender_prices(self).each do |price|
                    next unless price.interval?
                    billing_notifications.active.where(package_price_id: price.id).update_all(status: 3)
                    billing_notifications.build(package_price_id: price.id, billing_date: Date.today + price.interval).save!
                end
            end
        end
    end
end