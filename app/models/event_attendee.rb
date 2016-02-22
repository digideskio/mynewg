# EventAttendee Documentation
#
# == Schema Information
#
# Table name: event_attendees
#
#  id                       :integer          not null, primary key
#  event_id                 :integer
#  attendee_id              :integer
#  checked_in               :boolean          default(false)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class EventAttendee < ActiveRecord::Base
    include HasInvites

    belongs_to :attendee,                                           class_name: 'User', counter_cache: :count_of_attending_events
    belongs_to :event,                                              counter_cache: :count_of_attendees

    validates :event_id, :attendee_id,                              presence: true
    validates :attendee_id,                                         uniqueness: { scope: :event_id }
end
