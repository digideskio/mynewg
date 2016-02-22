require "rails_helper"

describe "Events API", type: :api do
  disable_omise

  describe "GET /v1/users/{user_id}/events" do
    subject { json(last_response) }

    let(:package) { create(:package) }
    let(:user) { create(:member, package: package) }
    let!(:event_1) { create(:event, packages: [package], start_date: 2.days.from_now, end_date: 3.days.from_now)}
    let!(:event_2) { create(:event, packages: [package], start_date: 1.days.from_now, end_date: 2.day.from_now)}
    before(:each) do
      create(:event_attendee, attendee_id: user.id, event_id: event_1.id)
      create(:event_attendee, attendee_id: user.id, event_id: event_2.id)
    end

    it "lists all events for a user" do
      login_as user

      get "http://api.example.com/v1/users/#{user.id}/events.json"

      is_expected.to match({
        "events" => [
          {
            "uid" => event_2.id,
            "title" => event_2.name,
            "info" => event_2.description,
            "location" => event_2.location,
            "start" => "#{event_2.start_date}",
            "end" => "#{event_2.end_date}",
            "attendees" => 1,
            "max_attendees" => event_2.max_attendees,
            "is_attending" => true,
            "can_attend" => true,
            "thumb_url" => event_2.hero_photo.file.thumb.url,
            "standard_url" => event_2.hero_photo.file.standard.url
          },
          {
            "uid" => event_1.id,
            "title" => event_1.name,
            "info" => event_1.description,
            "location" => event_1.location,
            "start" => "#{event_1.start_date}",
            "end" => "#{event_1.end_date}",
            "attendees" => 1,
            "max_attendees" => event_1.max_attendees,
            "is_attending" => true,
            "can_attend" => true,
            "thumb_url" => event_1.hero_photo.file.thumb.url,
            "standard_url" => event_1.hero_photo.file.standard.url
          }
        ]
      })
    end
  end

  describe "GET /v1/events" do
    subject { json(last_response) }

    let(:package) { create(:package) }
    let(:user) { create(:member, package: package) }
    let!(:event_1) { create(:event, packages: [package], start_date: 2.days.from_now, end_date: 3.days.from_now)}
    let!(:event_2) { create(:event, packages: [package], start_date: 1.days.from_now, end_date: 2.day.from_now)}
    before(:each) do
      create(:event, packages: [package], end_date: Date.yesterday, start_date: 2.days.ago)
    end

    it "lists all attendable events" do
      login_as user

      get "http://api.example.com/v1/events.json"

      is_expected.to match({
        "events" => [
          {
            "uid" => event_2.id,
            "title" => event_2.name,
            "info" => event_2.description,
            "location" => event_2.location,
            "start" => "#{event_2.start_date}",
            "end" => "#{event_2.end_date}",
            "attendees" => event_2.count_of_attendees,
            "max_attendees" => event_2.max_attendees,
            "is_attending" => false,
            "can_attend" => true,
            "thumb_url" => event_2.hero_photo.file.thumb.url,
            "standard_url" => event_2.hero_photo.file.standard.url
          },
          {
            "uid" => event_1.id,
            "title" => event_1.name,
            "info" => event_1.description,
            "location" => event_1.location,
            "start" => "#{event_1.start_date}",
            "end" => "#{event_1.end_date}",
            "attendees" => event_1.count_of_attendees,
            "max_attendees" => event_1.max_attendees,
            "is_attending" => false,
            "can_attend" => true,
            "thumb_url" => event_1.hero_photo.file.thumb.url,
            "standard_url" => event_1.hero_photo.file.standard.url
          }
        ]
      })
    end
  end

  describe "GET /v1/events/{event_id}" do
    subject { json(last_response) }

    let(:package) { create(:package) }
    let(:user) { create(:member, package: package) }
    let!(:event) { create(:event, packages: [package]) }

    it "returns an event" do
      login_as user

      get "http://api.example.com/v1/events/#{event.id}.json"

      is_expected.to match({
        "event" =>
          {
            "uid" => event.id,
            "title" => event.name,
            "info" => event.description,
            "location" => event.location,
            "start" => "#{event.start_date}",
            "end" => "#{event.end_date}",
            "attendees" => event.count_of_attendees,
            "max_attendees" => event.max_attendees,
            "is_attending" => false,
            "can_attend" => true,
            "thumb_url" => event.hero_photo.file.thumb.url,
            "standard_url" => event.hero_photo.file.standard.url
          }
      })
    end
  end

  describe "GET /v1/events/{event_id}/attendees" do
    subject { json(last_response) }

    let(:package) { create(:package) }
    let(:users) { create_list(:member, 2, package: package) }
    let(:event) { create(:event, packages: [package], max_attendees: 2) }

    it "lists all attendees of the event" do
      event.attendees << users

      login_as users.first

      get "http://api.example.com/v1/events/#{event.id}/attendees.json"

      is_expected.to match({
        "attendees" => [
          {
            "uid" => an_instance_of(Fixnum),
            "name" => users.first.name,
            "avatar_url" => users.first.profile_photo.file.square.url
          },
          {
            "uid" => an_instance_of(Fixnum),
            "name" => users.second.name,
            "avatar_url" => users.second.profile_photo.file.square.url
          }
        ]
      })
    end
  end

  describe "POST /v1/events/join" do
    let(:package) { create(:package, tier: 1) }
    let(:users) { create_list(:member, 3, package: package) }
    let(:event) { create(:event, max_attendees: 2, packages: [package]) }

    context "if the event is not full and/or the user has the required package access" do
      subject { json(last_response) }

      it "should join the user with event" do
        login_as users.first

        expect {
          post "http://api.example.com/v1/events/join.json", {event_attendee: { event_id: event.id}}
        }.to change(EventAttendee, :count).by(1)

        is_expected.to match({
          "event_attendee" =>
            {
              "uid" => an_instance_of(Fixnum),
              "event_id" => event.id,
              "attendee_id" => users.first.id,
              "checked_in" => false
            }
        })
      end
    end

    context "if the user does not have the required package access" do
      subject { json(last_response) }
      let(:silver_package) { create(:silver_package, tier: 2) }
      let(:silver_event) { create(:event, packages: [silver_package])}

      it "should return an error" do
        login_as users.first

        expect {
          post "http://api.example.com/v1/events/join.json", {event_attendee: { event_id: silver_event.id}}
        }.to change(EventAttendee, :count).by(0)

        is_expected.to match({"errors" => "Your package does not allow you to perform this action."})
      end
    end

    context "if the event is full" do
      subject { json(last_response) }
      before(:each) do
        users.last(2).map{|u| create(:event_attendee, event_id: event.id, attendee_id: u.id) }
      end

      it "should return an error" do
        login_as users.first

        expect {
          post "http://api.example.com/v1/events/join.json", {event_attendee: { event_id: event.id}}
        }.to change(EventAttendee, :count).by(0)

        is_expected.to match({"errors" => "You can't join this event. This event has reached the maximum allowed attendees."})
      end
    end
  end

  describe "DELETE /v1/events/{event_id}/unjoin" do
    subject { status(last_response) }
    let(:package) { create(:package) }
    let(:user) { create(:member, package: package) }
    let(:event) { create(:event, max_attendees: 2, packages: [package]) }
    before(:each) do
      create(:event_attendee, attendee_id: user.id, event_id: event.id)
    end


    it "should unjoin and destroy the event attendee" do
      login_as user

      expect {
        delete "http://api.example.com/v1/events/#{event.id}/unjoin.json"
      }.to change(EventAttendee, :count).by(-1)

      is_expected.to eq 204
    end
  end

  describe "POST /v1/events/{event_id}/invite/{user_id}" do
    let(:package) { create(:package) }
    let(:event) { create(:event, max_attendees: 2, packages: [package]*2) }
    let(:users) { create_list(:member, 3, package: package) }

    context "if the event is not full and/or the user is not already attending" do
      subject { status(last_response) }
      before(:each) do
        create(:event_attendee, event_id: event.id, attendee_id: users.first.id)
      end

      it "should send an invite to the target user" do
        login_as users.first

        expect {
          post "http://api.example.com/v1/events/%{id}/invite/%{user_id}.json" % {id: event.id, user_id: users.second.id}
        }.to change(Notification, :count).by(1)

        is_expected.to eq 201
      end
    end

    context "if the target user is already attending the event" do
      subject { json(last_response) }
      before(:each) do
        create(:event_attendee, event_id: event.id, attendee_id: users.second.id)
      end

      it "should return an error" do
        login_as users.first

        expect {
          post "http://api.example.com/v1/events/%{id}/invite/%{user_id}.json" % {id: event.id, user_id: users.second.id}
        }.to change(Notification, :count).by(0)

        is_expected.to match({"errors" => "This user is already attending the event."})
      end
    end

    context "if the event is full" do
      subject { json(last_response) }
      before(:each) do
        users.first(2).map{|u| create(:event_attendee, event_id: event.id, attendee_id: u.id) }
      end

      it "should return an error" do
        login_as users.first

        expect {
          post "http://api.example.com/v1/events/%{id}/invite/%{user_id}.json" % {id: event.id, user_id: users.third.id}
        }.to change(Notification, :count).by(0)

        is_expected.to match({"errors" => "You can't join this event. This event has reached the maximum allowed attendees."})
      end
    end
  end
end
