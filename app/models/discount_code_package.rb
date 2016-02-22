# DiscountCodePackage Documentation
#
# == Schema Information
#
# Table name: discount_code_packages
#
#  id                       :integer          not null, primary key
#  discount_code_id         :integer
#  package_id               :integer          
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class DiscountCodePackage < ActiveRecord::Base

    belongs_to :discount_code
    belongs_to :package
end
