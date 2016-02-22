# DiscountCodeUser Documentation
#
# == Schema Information
#
# Table name: discount_code_users
#
#  id                       :integer          not null, primary key
#  discount_code_id         :integer
#  user_id                  :integer          
#  status                   :integer          default(0)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class DiscountCodeUser < ActiveRecord::Base

    belongs_to :discount_code
    belongs_to :user

    validates :discount_code_id, :user_id,                      presence: true

    enum status: [:active, :archived]
end
