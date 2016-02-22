require "rails_helper"

describe "RepresentativeCodes API", type: :api do
  disable_omise

  describe "POST /v1/users/validate_code" do
    subject { json(last_response) }

    let(:available_representative_code) { create(:representative_code) }
    let(:used_representative_code) { create(:used_representative_code) }

    context "if the code has NOT been used" do
      it "should return an available status" do

        post "http://api.example.com/v1/users/validate_code.json", {code: available_representative_code.value }

        is_expected.to match({
          "code_available" => true,
          "gender" => "female"
        })
      end
    end

    context "if the code has been used" do
      it "should return a used status" do

        post "http://api.example.com/v1/users/validate_code.json", {code: used_representative_code.value }

        is_expected.to match({
          "code_available" => false,
          "gender" => "unknown"
        })
      end
    end

    context "when submitted an invalid code" do
      it "should return a used status" do

        post "http://api.example.com/v1/users/validate_code.json", { code: ('0'..'z').to_a.sample(8).join }

        is_expected.to match({
          "code_available" => false,
          "gender" => "unknown"
        })
      end
    end
  end

  describe "PATCH /v1/users/assign_code" do
    subject { json(last_response) }

    let(:package) { create(:silver_package) }
    let(:available_representative_code) { create(:representative_code) }
    let(:used_representative_code) { create(:used_representative_code) }
    let(:user) { create(:junior_rep, package_id: package.id) }
    let(:user_with_code) { create(:member, package_id: package.id) }
    let(:representative_code) { create(:representative_code, member_id: user_with_code.id) }

    context "when the code is invalid" do

      it "should return a 422 error with a message" do
        login_as user

        patch "http://api.example.com/v1/users/assign_code.json", { code: ('0'..'z').to_a.sample(8).join }

        is_expected.to match({"errors" => "Invalid sales code. Please contact support."})
      end
    end

    context "if the code has been used" do

      it "should return a 422 error with a message" do
        login_as user

        patch "http://api.example.com/v1/users/assign_code.json", { code: used_representative_code.value }

        is_expected.to match({"errors" => "Invalid sales code. Please contact support."})
      end
    end

    context "if a code has already been assigned to the current user" do
      it "should return a 422 error with a message" do
        login_as user_with_code

        patch "http://api.example.com/v1/users/assign_code.json", { code: available_representative_code.value }

        is_expected.to match({"errors" => "You already have a sales code associated with your account."})
      end
    end

    context "if a code is available and the user has no assigned code" do
      subject { status(last_response) }

      it "should return a 204 no content" do
        login_as user

        patch "http://api.example.com/v1/users/assign_code.json", { code: available_representative_code.value }

        is_expected.to equal 204

        available_representative_code.reload
        expect(available_representative_code.status).to eq 'used'
      end
    end
  end
end
