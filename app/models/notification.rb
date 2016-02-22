# Notification Documentation
#
# == Schema Information
#
# Table name: notifications
#
#  id                       :integer          not null, primary key
#  category                 :integer
#  user_id                  :integer
#  event_id                 :integer
#  source_id                :integer
#  text                     :string(255)
#  state                    :integer          default(0)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class Notification < ActiveRecord::Base

    belongs_to :user
    belongs_to :source,                                                                 class_name: 'User'
    belongs_to :event

    validates :category, :user_id, :source_id, :text,                                    presence: true
    validates :event_id,                                                                 presence: true, :if => :invite?
    validates :user_id,                                                                  uniqueness: { scope: [:source_id, :category, :event_id], message: 'has already been notified.' }, :if => :active?
    validate  :validate_event_max_attendees, if: :invite?

    scope :archivable,                                                                  -> { where('created_at < ?', 29.days.ago) }

    enum category: [:like, :invite, :match, :attending]
    enum state: [:unread, :read]
    enum status: [:active, :archived]

    before_validation :set_notification_message,                                        on: :create

    default_scope { order(created_at: :desc) }

    def set_notification_message
        source = User.find(source_id)
        event = Event.find(event_id) if event?
        if like?
            self.text = "#{source.name} likes you"
        elsif invite?
            self.text = "#{source.name} invited you to #{event.name}"
        elsif match?
            self.text = "#{source.name} and you are a match!"
        elsif attending?
            self.text = "#{source.name} is attending #{event.name}"
        end
    end

    def event?
        invite? || attending?
    end

    def validate_event_max_attendees
      raise CustomError::MaxAttendee if event.maximum_attendees?
    end
end


