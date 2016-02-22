require "rails_helper"

describe "Messages API", type: :api do
  disable_omise

  describe "GET /v1/chats/{chat_id}/messages" do
    subject { json(last_response) }

    let(:package) { create(:package) }
    let(:user) { create(:member, package: package) }
    let(:chat) { create(:chat) }
    let!(:messages) { create_list(:message, 3, chat_id: chat.id, user_id: user.id, state: 'unread') }
    before(:each) do
      create(:participant, user_id: user.id, chat_id: chat.id)
    end

    it "lists all messages for a chat" do
      login_as user

      get "http://api.example.com/v1/chats/#{chat.id}/messages.json"

      is_expected.to match({
        "total" => 3,
        "per_page" => 25,
        "pages" => 1,
        "current_page" => 1,
        "current_page_count" => 3,
        "messages" => [
          {
            "uid" => messages.third.id,
            "chat_id" => chat.id,
            "user_id" => user.id,
            "is_read" => false,
            "is_self" => true,
            "text" => messages.third.text,
            "sent_time" => "#{messages.third.created_at}"
          },
          {
            "uid" => messages.second.id,
            "chat_id" => chat.id,
            "user_id" => user.id,
            "is_read" => false,
            "is_self" => true,
            "text" => messages.second.text,
            "sent_time" => "#{messages.second.created_at}"
          },
          {
            "uid" => messages.first.id,
            "chat_id" => chat.id,
            "user_id" => user.id,
            "is_read" => false,
            "is_self" => true,
            "text" => messages.first.text,
            "sent_time" => "#{messages.first.created_at}"
          }
        ]
      })
    end
  end

  describe "POST /v1/messages" do
    subject { json(last_response) }

    let(:package) { create(:silver_package) }
    let(:user) { create(:member, package: package) }
    let(:platinum) { create(:platinum, package: package) }
    let(:chat) { create(:chat) }
    before(:each) do
      create(:participant, user_id: user.id, chat_id: chat.id)
      create(:participant, user_id: platinum.id, chat_id: chat.id)
    end

    it "creates a message" do
      login_as user

      expect {
        post "http://api.example.com/v1/messages.json", {message: {chat_id: chat.id, text: 'Hey there!'
          }}
      }.to change(Message, :count).by(1)

      is_expected.to match({
        "message" => {
          "uid" => an_instance_of(Fixnum),
          "chat_id" => chat.id,
          "user_id" => user.id,
          "is_read" => false,
          "is_self" => true,
          "text" => 'Hey there!',
          "sent_time" => "#{chat.messages.first.created_at}"
        }
      })
    end
  end
end
