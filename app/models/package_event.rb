# PackageEvent Documentation
#
# == Schema Information
#
# Table name: package_events
#
#  id                       :integer          not null, primary key
#  package_id               :integer
#  event_id                 :integer          
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class PackageEvent < ActiveRecord::Base

    belongs_to :package
    belongs_to :event
end
