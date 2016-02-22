class Appointment < ActiveRecord::Base
  belongs_to :user

  # validates :scheduled_time, presence: true
  validate :ensure_future_scheduled_time, if: :scheduled_time_changed?

  def ensure_future_scheduled_time
    unless scheduled_time && scheduled_time > Time.now
      errors.add(:scheduled_time, "must be in the future")
    end
  end
end
