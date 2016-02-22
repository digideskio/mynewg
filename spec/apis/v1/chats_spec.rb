require "rails_helper"

describe "Chats API", type: :api do
  disable_omise

  subject { json(last_response) }
  let(:user) { create(:lead) }
  let(:other_user) { create(:platinum) }

  describe "GET /v1/chats.json" do

    context "if a user has 'lead' role" do
      it "blocks a user" do
        login_as user

        get "http://api.example.com/v1/chats.json"

        is_expected.to match({"errors" => "You do not have permission to chat with this user."})
      end
    end
  end

  describe "POST /v1/chats.json" do

    context "if a user has 'lead' role" do
      it "blocks a user" do
        login_as user

        post "http://api.example.com/v1/chats.json", {chat_user_id: other_user.id}

        is_expected.to match({"errors" => "You do not have permission to chat with this user."})
      end
    end
  end

  describe "DELETE /v1/chats/{chat_id}" do
    subject { status(last_response) }

    let(:package) { create(:package) }
    let(:user) { create(:member, package: package) }
    let(:chat) { create(:chat) }
    before(:each) do
      create(:participant, user_id: user.id, chat_id: chat.id)
    end

    it "destroys a chat" do
      login_as user

      expect {
        delete "http://api.example.com/v1/chats/#{chat.id}.json"
      }.to change(Chat, :count).by(-1)

      is_expected.to equal 204      
    end
  end
end
