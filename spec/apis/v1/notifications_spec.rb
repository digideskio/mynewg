require "rails_helper"

describe "Notifications API", type: :api do
  disable_omise

  describe "GET /v1/users/notifications" do
    subject { json(last_response) }

    let(:package) { create(:package) }
    let(:user) { create(:member, package: package) }
    let(:other_user) { create(:platinum, package: package) }
    let(:event) { create(:event, packages: [package]) }
    let!(:invite_notification) { create(:invite_notification, user_id: other_user.id, source_id: user.id, event: event) }
    let!(:match_notification) { create(:match_notification, user_id: other_user.id, source_id: user.id, state: 'unread') }
    let!(:attending_notification) { create(:attending_notification, user_id: user.id, source_id: other_user.id, event: event) }


    it "lists all notifications for a user" do
      login_as other_user

      get "http://api.example.com/v1/users/notifications.json"

      is_expected.to match({
        "notifications" => [
          {
            "uid" => match_notification.id,
            "is_match" => true,
            "is_like" => false,
            "text" => "#{user.name} and you are a match!",
            "user_id" => other_user.id,
            "event_id" => nil,
            "source_id" => user.id,
            "is_read" => false,
            "sent_time" => "#{match_notification.created_at}"
          },
          {
            "uid" => invite_notification.id,
            "is_match" => false,
            "is_like" => false,
            "text" => "#{user.name} invited you to #{event.name}",
            "user_id" => other_user.id,
            "event_id" => event.id,
            "source_id" => user.id,
            "is_read" => true,
            "sent_time" => "#{invite_notification.created_at}"
          }
        ]
      })
    end
  end

  describe "PATCH /v1/users/notifications/{notification_id}/read" do
    subject { status(last_response) }

    let(:package) { create(:package) }
    let(:user) { create(:member, package: package) }
    let!(:other_user) { create(:member, package: package) }
    let!(:match_notification) { create(:match_notification, user_id: user.id, source_id: other_user.id, state: 'unread') }

    it "updates a notification as read" do
      login_as user

      patch "http://api.example.com/v1/users/notifications/#{match_notification.id}/read.json"

      is_expected.to equal 204

      match_notification.reload
      expect(match_notification.state).to eq 'read'
    end
  end
end
