require "rails_helper"

describe "Attachments API", type: :api do
  disable_omise

  describe "GET /v1/users/{user_id}/images" do
    subject { json(last_response) }

    context "one user, multiple attachments" do
      let(:package) { create(:package) }
      let(:user) { create(:member, package: package) }
      let!(:gallery_attachments) { create_list(:gallery_attachment, 2, attachable_id: user.id) }
      before(:each) do
        create(:cover_attachment, attachable_id: user.id)
      end

      it "lists all gallery images for a user" do
        login_as user

        get "http://api.example.com/v1/users/#{user.id}/images.json"

        is_expected.to match({
          "images" => [
            {
              "uid" => gallery_attachments.first.id,
              "user_id" => user.id,
              "thumb_url" => gallery_attachments.first.file.thumb.url,
              "standard_url" => gallery_attachments.first.file.standard.url
            },
            {
              "uid" => gallery_attachments.second.id,
              "user_id" => user.id,
              "thumb_url" => gallery_attachments.second.file.thumb.url,
              "standard_url" => gallery_attachments.second.file.standard.url
            }
          ]
        })
      end
    end

    context "multiple users, multiple attachments" do
      let(:package) { create(:package) }
      let(:users) { create_list(:member, 5, package: package) }
      let(:gallery_attachments) { create_list(:gallery_attachment, 10) }
      before(:each) do
        gallery_attachments.each do |a|
          users.sample.photos << a
        end
      end

      it "lists own gallery images only" do
        login_as users.first

        get "http://api.example.com/v1/users/#{users.first.id}/images.json"

        expect(subject["images"].map { |i| i["uid"] }).to match(users.first.gallery_photo_ids)
      end

      it "lists someone's gallery images only" do
        login_as users.first

        get "http://api.example.com/v1/users/#{users.last.id}/images.json"

        expect(subject["images"].map { |i| i["uid"] }).to match(users.last.gallery_photo_ids)
      end
    end
  end

  # describe "POST /v1/images" do
  #   subject { json(last_response) }

  #   let(:package) { create(:package) }
  #   let(:user) { create(:member, package: package) }

  #   it "creates an image for a user" do
  #     login_as user

  #     expect {
  #         post "http://api.example.com/v1/images.json", {attachment: { file: 'https://fbcdn-sphotos-d-a.akamaihd.net/hphotos-ak-xap1/v/t1.0-9/11230652_10156021711250461_1873256135850723352_n.jpg?oh=32feee067374ed9d2883c22e8a8d4c08&oe=568CD856&__gda__=1452301827_39ca4b2b0145211f87e1ee28aba317a0' }}
  #     }.to change(Attachment, :count).by(1)

  #     is_expected.to match({
  #       "attachment" => {
  #         "uid" => user.gallery_photos.first.id,
  #         "user_id" => user.id,
  #         "thumb_url" => user.gallery_photos.first.file.thumb.url,
  #         "standard_url" => user.gallery_photos.first.file.standard.url
  #       }
  #     })
  #   end
  # end

  # describe "PATCH /v1/images/{image_id}/set_avatar" do
  #   subject { status(last_response) }

  #   let(:package) { create(:package) }
  #   let(:user) { create(:member, package: package) }
  #   let!(:gallery_attachment) { create(:gallery_attachment, attachable_id: user.id) }

  #   it "sets a gallery photo as the user's profile photo" do
  #     login_as user

  #     patch "http://api.example.com/v1/images/#{gallery_attachment.id}/set_avatar.json"

  #     is_expected.to equal 204

  #     gallery_attachment.reload
  #     expect(gallery_attachment.attachable_type).to eq 'ProfilePhoto'
  #   end
  # end

  describe "DELETE /v1/images/{image_id}" do
    subject { status(last_response) }

    let(:package) { create(:package) }
    let(:user) { create(:member, package: package) }
    let!(:gallery_attachment) { create(:gallery_attachment, attachable_id: user.id) }

    it "destroys an image" do
      login_as user

      expect {
        delete "http://api.example.com/v1/images/#{gallery_attachment.id}.json"
      }.to change(Attachment, :count).by(-1)

      is_expected.to equal 204
    end
  end
end
