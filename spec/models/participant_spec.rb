require 'rails_helper'

describe Participant do
  disable_omise

  describe "chats" do
    let(:package) { create(:package) }
    let(:users) { create_list(:member, 3, package: package) }
    let(:chat) { create(:chat) }

    it "destroys chats when there's only one participant left" do
      chat.users << users[0,2]

      expect {
        users.first.destroy
      }.to change(Chat, :count).by(-1)
    end

    it "does not user's chat with the user record so there's no chat with one participant" do
      chat.users << users

      expect {
        users.first.destroy
      }.not_to change(Chat, :count)
    end
  end
end