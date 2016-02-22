# UserManager Documentation
#
# == Schema Information
#
# Table name: user_managers
#
#  id                       :integer          not null, primary key
#  junior_id                :integer
#  senior_id                :integer          
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class UserManager < ActiveRecord::Base

    belongs_to :senior,                 class_name: 'User', foreign_key: 'senior_id'
    belongs_to :junior,                 class_name: 'User', foreign_key: 'junior_id'
end
