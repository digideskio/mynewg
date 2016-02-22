# Search Documentation
#
# == Schema Information
#
# Table name: searches
#
#  id                       :integer          not null, primary key
#  query                    :string(255)
#  searched_at              :datetime
#  converted_at             :datetime
#  user_id                  :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class Search < ActiveRecord::Base

    belongs_to :user
end
