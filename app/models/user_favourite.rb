# UserFavourite Documentation
#
# == Schema Information
#
# Table name: user_favourites
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  favourite_id             :integer       
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class UserFavourite < ActiveRecord::Base

    belongs_to :user
    belongs_to :favourite,                                  class_name: 'User'

    validates :user_id, :favourite_id,                      presence: true
    validates :favourite_id,                                uniqueness: { scope: :user_id }
end
