# BillingNotification Documentation
#
# == Schema Information
#
# Table name: billing_notifications
#
#  id                           :integer          not null, primary key
#  billing_date                 :datetime         
#  user_id                      :integer   
#  package_price_id             :integer
#  status                       :integer          default(0)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
class BillingNotification < ActiveRecord::Base

    belongs_to :user
    belongs_to :package_price

    validates :billing_date, :user_id, :package_price_id,               presence: true

    enum status: [:active, :archived, :failed, :last_for_package]
end
