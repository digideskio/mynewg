require "rails_helper"

describe Notification do
  disable_omise

  let(:event) { create(:event, max_attendees: 2, packages: [package]*2) }
  let(:package) { create(:package) }
  let(:users) { create_list(:member, 3, package: package) }

  it "raises an error when trying to invite a user to an event that's already full" do
    event.attendees << users[0..-2]

    expect { Notification.create(
      source: users.first,
      user: users.third,
      category: :invite,
      event: event,
    ) }.to raise_error(CustomError::MaxAttendee)
  end
end
