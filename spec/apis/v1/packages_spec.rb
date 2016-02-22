require "rails_helper"

describe "Packages API", type: :api do
  disable_omise

  describe "GET /v1/packages" do
    subject { json(last_response) }

    let!(:package_1) { create(:package, tier: 0) }
    let!(:package_2) { create(:package, tier: 1) }
    let(:user) { create(:member, package: package_1) }

    it "lists all packages" do
      login_as user

      get "http://api.example.com/v1/packages.json"

      is_expected.to match({
        "packages" => [
          {
            "name" => package_1.name
          },
          {
            "name" => package_2.name
          }
        ]
      })
    end
  end
end
