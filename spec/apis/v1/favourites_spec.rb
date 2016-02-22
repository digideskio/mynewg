require "rails_helper"

describe "Favourites API", type: :api do
  disable_omise

  describe "GET /v1/users/favourites" do
    subject { json(last_response) }

    let(:package) { create(:package) }
    let(:user) { create(:member, package: package) }
    let(:users) { create_list(:member, 2, package: package) }
    let!(:favourite_1) { create(:user_favourite, user_id: user.id, favourite_id: users.first.id) }
    let!(:favourite_2) { create(:user_favourite, user_id: user.id, favourite_id: users.second.id) }

    it "lists all favourites for current user" do
      login_as user

      get "http://api.example.com/v1/users/favourites.json"

      is_expected.to match({
        "users" => [
          {
            "uid" => users.first.id,
            "age" => users.first.age,
            "appointment_time" => nil,
            "avatar_url" => users.first.profile_photo.file.square.url,
            "can_chat" => false,
            "cover_photo_url" => users.first.cover_photo.file.cover.url,
            "current_chat_id" => nil,
            "drink" => users.first.drink,
            "email" => users.first.email,
            "english" => users.first.english,
            "events" => users.first.count_of_attending_events,
            "favourite_id" => an_instance_of(Fixnum),
            "gender" => users.first.gender,
            "height" => users.first.height,
            "is_admin" => false,
            "is_blocked" => false,
            "is_favourite" => true,
            "is_flagged" => false,
            "is_frozen" => false,
            "is_junior_representative" => false,
            "is_lead" => false,
            "is_limited" => false,
            "is_match" => false,
            "is_member" => true,
            "is_senior_representative" => false,
            "kids" => users.first.kids,
            "line_id" => users.first.line_id,
            "location" => users.first.location,
            "name" => users.first.name,
            "package" => package.name,
            "phone" => users.first.phone,
            "smoke" => users.first.smoke,
            "thai" => users.first.thai,
            "username" => users.first.username,
            "display_name" => users.first.full_display_name,
            "nickname" => users.first.full_display_name,
            "biography" => users.first.biography,
            "locale" => users.first.locale,
            "provider" => users.first.provider,
            "created_at" => "#{users.first.created_at}",
            "updated_at" => "#{users.first.updated_at}"
          },
          {
            "uid" => users.second.id,
            "age" => users.second.age,
            "appointment_time" => nil,
            "avatar_url" => users.second.profile_photo.file.square.url,
            "can_chat" => false,
            "cover_photo_url" => users.second.cover_photo.file.cover.url,
            "current_chat_id" => nil,
            "drink" => users.second.drink,
            "email" => users.second.email,
            "english" => users.second.english,
            "events" => users.second.count_of_attending_events,
            "favourite_id" => an_instance_of(Fixnum),
            "gender" => users.second.gender,
            "height" => users.second.height,
            "is_admin" => false,
            "is_blocked" => false,
            "is_favourite" => true,
            "is_flagged" => false,
            "is_frozen" => false,
            "is_junior_representative" => false,
            "is_lead" => false,
            "is_limited" => false,
            "is_match" => false,
            "is_member" => true,
            "is_senior_representative" => false,
            "kids" => users.second.kids,
            "line_id" => users.second.line_id,
            "location" => users.second.location,
            "name" => users.second.name,
            "package" => package.name,
            "phone" => users.second.phone,
            "smoke" => users.second.smoke,
            "thai" => users.second.thai,
            "username" => users.second.username,
            "display_name" => users.second.full_display_name,
            "nickname" => users.second.full_display_name,
            "biography" => users.second.biography,
            "locale" => users.second.locale,
            "provider" => users.second.provider,
            "created_at" => "#{users.second.created_at}",
            "updated_at" => "#{users.second.updated_at}"
          }
        ]
      })
    end
  end

  describe "POST /v1/favourites" do
    subject { json(last_response) }

    let(:package) { create(:package) }
    let(:user) { create(:member, package: package) }
    let!(:other_user) { create(:member, package: package) }

    it "favourites a user" do
      login_as user

      expect {
          post "http://api.example.com/v1/favourites.json", {favourite: { favourite_id: other_user.id }}
      }.to change(UserFavourite, :count).by(1)

      is_expected.to match({
        "favourite" => {
          "uid" => an_instance_of(Fixnum),
          "user_id" => user.id,
          "favourite_id" => other_user.id
        }
      })
    end
  end

  describe "DELETE /v1/flag/{flagged_id}" do
    subject { status(last_response) }

    let(:package) { create(:package) }
    let(:user) { create(:member, package: package) }
    let!(:other_user) { create(:member, package: package) }
    let!(:favourite) { create(:user_favourite, user_id: user.id, favourite_id: other_user.id) }


    it "destroys a favourite" do
        login_as user

        expect {
            delete "http://api.example.com/v1/favourites/#{favourite.id}.json"
        }.to change(UserFavourite, :count).by(-1)

      is_expected.to equal 204      
    end
  end
end
