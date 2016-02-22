require 'rails_helper'

describe User do

    disable_omise

    describe "When checking if a user can chat with another user" do

        context "if either user is an admin and neither is blocking" do
            let!(:admin) { create(:admin) }
            let!(:user) { create(:junior_rep) }


            it "should return true" do
                expect(user.can_chat?(admin)).to eq true
                expect(admin.can_chat?(user)).to eq true
            end
        end

        context "if either user is a female and neither is blocking" do
            let(:silver_package) { create(:silver_package) }
            let!(:female_member) { create(:female_member, package: silver_package) }
            let!(:user) { create(:junior_rep, package: silver_package) }


            it "should return true" do
                expect(user.can_chat?(female_member)).to eq true
                expect(female_member.can_chat?(user)).to eq true
            end
        end

        context "if one is blocking" do
            let(:silver_package) { create(:silver_package) }
            let!(:female_member) { create(:female_member, package: silver_package) }
            let!(:user) { create(:junior_rep, package: silver_package) }

            before(:each) do
                create(:user_block, user_id: female_member.id, blocked_id: user.id)
            end


            it "should return false" do
                expect(user.can_chat?(female_member)).to eq false
                expect(female_member.can_chat?(user)).to eq false
            end
        end
    end
end