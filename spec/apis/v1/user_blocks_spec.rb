require "rails_helper"

describe "UserBlocks API", type: :api do
  disable_omise

  describe "POST /v1/users/block" do
    subject { json(last_response) }

    let(:package) { create(:package) }
    let(:users) { create_list(:member, 2, package: package) }

    it "blocks a user" do
      login_as users.first

      expect {
        post "http://api.example.com/v1/users/block.json", {user_block: {blocked_id: users.second.id}}
      }.to change(UserBlock, :count).by(1)

      is_expected.to match({
        "user_block" => {
          "uid" => an_instance_of(Fixnum),
          "user_id" => users.first.id,
          "blocked_id" => users.second.id
        }
      })
    end
  end

  describe "DELETE /v1/users/block/{blocked_id}" do
    subject { status(last_response) }

    let(:package) { create(:package) }
    let(:user) { create(:member, package: package) }
    let!(:other_user) { create(:member, package: package) }
    let!(:block) { create(:user_block, user_id: user.id, blocked_id: other_user.id) }


    it "destroys a block" do
      login_as user

      expect {
        delete "http://api.example.com/v1/users/block/#{other_user.id}.json"
      }.to change(UserBlock, :count).by(-1)

      is_expected.to equal 204      
    end
  end
end
