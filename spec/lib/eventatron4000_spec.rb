require "rails_helper"
require "#{Rails.root}/lib/eventatron_4000" # wut?

describe Eventatron4000 do
  disable_omise

  include ActiveJob::TestHelper

  it "sends reminders" do
    package = create(:package)
    members = create_list(:member, 2, package: package)
    event = create(:event, start_date: 7.days.from_now, packages: [package])
    event.attendees = members

    expect {
      perform_enqueued_jobs {
        Eventatron4000.send_reminders
      }
    }.to change { ActionMailer::Base.deliveries.count }.by(members.size)
  end

  it "creates matches" do
    package = create(:package)
    members = create_list(:member, 4, package: package)
    event = create(:event, start_date: 1.day.ago, end_date: 30.minutes.ago, packages: [package])
    event.attendees = members

    expect { Eventatron4000.create_matches }.to change { Match.count }.by(6)
  end

  it "should set the event matched attribute to true" do
    package = create(:package)
    members = create_list(:member, 4, package: package)
    event = create(:event, start_date: 1.day.ago, end_date: 30.minutes.ago, packages: [package])
    event.attendees = members

    expect{
      Eventatron4000.create_matches
    }.to change {
      event.reload
      event.matched
    }.from(false).to(true)
  end

  context "if an event has invite notifications" do
    let(:package) { create(:package) }
    let(:members) { create_list(:member, 4, package: package) }
    let(:member) { create(:member, package: package) }
    let(:event) { create(:event, start_date: 1.day.ago, end_date: 30.minutes.ago, packages: [package]) }
    
    before(:each) do
      event.attendees = members
      members.map{|m| create(:invite_notification, event: event, user: m, source: member) }
    end

    it "should archive all active invite notifications" do
      expect(event.active_invite_notifications.count).to eq 4
      Eventatron4000.create_matches
      expect(event.active_invite_notifications.count).to eq 0
      expect(event.archived_invite_notifications.count).to eq 4
    end
  end
end
