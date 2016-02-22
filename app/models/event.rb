# Event Documentation
#
# == Schema Information
#
# Table name: events
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  location               :string(255)
#  description            :text
#  start_date             :datetime
#  end_date               :datetime
#  matched                :boolean
#  max_attendees          :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Event < ActiveRecord::Base
    include HasAttendees

    has_many :package_events
    has_many :packages,                                                               through: :package_events
    has_one :hero_photo,                                                              -> { where(attachable_type: 'EventHeroPhoto') }, class_name: 'Attachment', foreign_key: 'attachable_id', dependent: :destroy
    has_many :active_invite_notifications,                                            -> { where(category: 1).where(status: 0) }, class_name: 'Notification', foreign_key: 'event_id', dependent: :destroy
    has_many :archived_invite_notifications,                                          -> { where(category: 1).where(status: 1) }, class_name: 'Notification', foreign_key: 'event_id', dependent: :destroy

    validates :name, :location, :description, :start_date, :end_date,                 presence: true
    validate  :end_after_start
    validates :name,                                                                  uniqueness: true
    validates :hero_photo,                                                            presence: true
    validates :max_attendees,                                                         numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    validate :package_count

    scope :has_attendees,                                                             -> { includes(:event_attendees, :attendees).where.not(event_attendees: { attendee_id: nil }) }
    scope :future_events,                                                             -> { where('start_date > ?', Time.now) }
    scope :past_events,                                                               -> { where('end_date < ?', Time.now) }
    scope :attendable,                                                                -> { where("end_date > ?", Time.now) }
    scope :sort_by_day,                                                               -> { includes(:attendees).all.order(start_date: :asc).group_by(&:start_day) }
    scope :unmatched,                                                                 -> { where(matched: false) }

    default_scope { order(start_date: :asc) }

    accepts_nested_attributes_for :hero_photo

    def package_count
        if self.packages.map(&:status).count == 0
            errors.add(:event, " must have at least one package.")
            return false
        end
    end

    def reminder_event?
        self.start_date.to_date === 7.days.from_now.to_date ? true : false
    end

    def match_event?
      !matched? && Time.now.between?(self.end_date, 1.hour.since(self.end_date))
    end

    def start_day
        self.start_date.strftime('%e %B')
    end

    private

    def end_after_start
        return if end_date.blank? || start_date.blank?

        if end_date < start_date
            errors.add(:end_date, 'must be after the start date')
        end
    end

end
