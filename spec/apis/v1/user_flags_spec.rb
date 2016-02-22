require "rails_helper"

describe "UserFlags API", type: :api do
  disable_omise

  describe "POST /v1/users/flag" do
    subject { json(last_response) }

    let(:package) { create(:package) }
    let(:user) { create(:member, package: package) }
    let!(:other_user) { create(:member, package: package) }

    it "flags a user" do
      login_as user

      expect {
        post "http://api.example.com/v1/users/flag.json", {user_flag: {flagged_id: other_user.id, reason: 'spam_messages', additional_info: 'I wish to no longer speak to her!'}}
      }.to change(UserFlag, :count).by(1)

      is_expected.to match({
        "user_flag" => {
          "uid" => an_instance_of(Fixnum),
          "user_id" => user.id,
          "flagged_id" => other_user.id,
          "reason" => 'spam_messages',
          "additional_info" => 'I wish to no longer speak to her!'
        }
      })
    end
  end

  describe "DELETE /v1/users/flag/{flagged_id}" do
    subject { status(last_response) }

    let(:package) { create(:package) }
    let(:user) { create(:member, package: package) }
    let!(:other_user) { create(:member, package: package) }
    let!(:flag) { create(:user_flag, user_id: user.id, flagged_id: other_user.id) }


    it "destroys a flag" do
      login_as user

      expect {
        delete "http://api.example.com/v1/users/flag/#{other_user.id}.json"
      }.to change(UserFlag, :count).by(-1)

      is_expected.to equal 204      
    end
  end
end
