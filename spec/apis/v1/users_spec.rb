require "rails_helper"

describe "Users API", type: :api do
    disable_omise

    describe "GET /v1/users/discover" do
        subject { json(last_response) }

        let(:package) { create(:package) }
        let(:user) { create(:member, package: package) }
        let!(:other_user) { create(:member, package: package) }
        before(:each) do
            create(:admin)
        end

        it "lists all other users" do
            login_as user

            get "http://api.example.com/v1/users/discover.json"

            is_expected.to match({
                "users" => [
                {
                    "uid" => other_user.id,
                    "age" => other_user.age,
                    "appointment_time" => nil,
                    "avatar_url" => other_user.profile_photo.file.square.url,
                    "can_chat" => false,
                    "cover_photo_url" => other_user.cover_photo.file.cover.url,
                    "current_chat_id" => nil,
                    "drink" => other_user.drink,
                    "email" => other_user.email,
                    "english" => other_user.english,
                    "events" => other_user.count_of_attending_events,
                    "favourite_id" => nil,
                    "gender" => other_user.gender,
                    "height" => other_user.height,
                    "is_admin" => false,
                    "is_blocked" => false,
                    "is_favourite" => false,
                    "is_flagged" => false,
                    "is_frozen" => false,
                    "is_junior_representative" => false,
                    "is_lead" => false,
                    "is_limited" => false,
                    "is_match" => false,
                    "is_member" => true,
                    "is_senior_representative" => false,
                    "kids" => other_user.kids,
                    "line_id" => other_user.line_id,
                    "location" => other_user.location,
                    "name" => other_user.name,
                    "package" => package.name,
                    "phone" => other_user.phone,
                    "smoke" => other_user.smoke,
                    "thai" => other_user.thai,
                    "username" => other_user.username,
                    "display_name" => other_user.full_display_name,
                    "nickname" => other_user.full_display_name,
                    "biography" => other_user.biography,
                    "locale" => other_user.locale,
                    "provider" => other_user.provider,
                    "created_at" => "#{other_user.created_at}",
                    "updated_at" => "#{other_user.updated_at}"
                }
                ]
            })
        end
    end

    describe "GET /v1/users/me" do
        subject { json(last_response) }

        let(:package) { create(:package) }
        let(:user) { create(:member, package: package) }

        it "returns the current user object" do
            login_as user

            get "http://api.example.com/v1/users/me.json"

            is_expected.to match({
                "user" => {
                    "uid" => user.id,
                    "age" => user.age,
                    "appointment_time" => nil,
                    "avatar_url" => user.profile_photo.file.square.url,
                    "cover_photo_url" => user.cover_photo.file.cover.url,
                    "drink" => user.drink,
                    "email" => user.email,
                    "english" => user.english,
                    "events" => user.count_of_attending_events,
                    "gender" => user.gender,
                    "height" => user.height,
                    "is_admin" => false,
                    "is_frozen" => false,
                    "is_junior_representative" => false,
                    "is_lead" => false,
                    "is_limited" => false,
                    "is_member" => true,
                    "is_senior_representative" => false,
                    "kids" => user.kids,
                    "line_id" => user.line_id,
                    "location" => user.location,
                    "name" => user.name,
                    "package" => package.name,
                    "phone" => user.phone,
                    "smoke" => user.smoke,
                    "thai" => user.thai,
                    "username" => user.username,
                    "display_name" => user.full_display_name,
                    "nickname" => user.full_display_name,
                    "biography" => user.biography,
                    "locale" => user.locale,
                    "provider" => user.provider,
                    "created_at" => "#{user.created_at}",
                    "updated_at" => "#{user.updated_at}"
                }
            })
        end
    end

    describe "GET /v1/users/{user_id}" do
        subject { json(last_response) }

        let(:package) { create(:package) }
        let(:user) { create(:member, package: package) }

        it "returns a user object" do
            login_as user

            get "http://api.example.com/v1/users/#{user.id}.json"

            is_expected.to match({
                "user" => {
                    "uid" => user.id,
                    "age" => user.age,
                    "appointment_time" => nil,
                    "avatar_url" => user.profile_photo.file.square.url,
                    "can_chat" => false,
                    "cover_photo_url" => user.cover_photo.file.cover.url,
                    "current_chat_id" => nil,
                    "drink" => user.drink,
                    "email" => user.email,
                    "english" => user.english,
                    "events" => user.count_of_attending_events,
                    "favourite_id" => nil,
                    "gender" => user.gender,
                    "height" => user.height,
                    "is_admin" => false,
                    "is_blocked" => false,
                    "is_favourite" => false,
                    "is_flagged" => false,
                    "is_frozen" => false,
                    "is_junior_representative" => false,
                    "is_lead" => false,
                    "is_limited" => false,
                    "is_match" => false,
                    "is_member" => true,
                    "is_senior_representative" => false,
                    "kids" => user.kids,
                    "line_id" => user.line_id,
                    "location" => user.location,
                    "name" => user.name,
                    "package" => package.name,
                    "phone" => user.phone,
                    "smoke" => user.smoke,
                    "thai" => user.thai,
                    "username" => user.username,
                    "display_name" => user.full_display_name,
                    "nickname" => user.full_display_name,
                    "biography" => user.biography,
                    "locale" => user.locale,
                    "provider" => user.provider,
                    "created_at" => "#{user.created_at}",
                    "updated_at" => "#{user.updated_at}"
                }
            })
        end
    end
end