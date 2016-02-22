# UserBlock Documentation
#
# == Schema Information
#
# Table name: user_blocks
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  blocked_id               :integer       
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class UserBlock < ActiveRecord::Base

    belongs_to :user, foreign_key: 'blocked_id'

    validates :user_id, :blocked_id,                    presence: true
    validates :blocked_id,                              uniqueness: { scope: :user_id }
    
end
