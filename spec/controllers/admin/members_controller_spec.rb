require 'rails_helper'

describe Admin::MembersController do

    disable_omise
    login_admin

    describe 'GET #view' do
        let!(:package) { create(:silver_package) }
        let!(:junior_rep_1) { create(:junior_rep, package_id: package.id) }
        let!(:junior_rep_2) { create(:junior_rep, package_id: package.id) }
        let!(:senior_rep) { create(:senior_rep, package_id: package.id) }

        it "should populate an array of users" do
            get :view
            expect(assigns(:members)).to match_array([User.admin.first, junior_rep_1, junior_rep_2, senior_rep])
        end
        it "should render the :view template" do
            get :view
            expect(response).to render_template :view
        end
    end

    describe 'GET #new' do
        it "should assign a new user to @member" do
            get :new
            expect(assigns(:member)).to be_a_new(User)
        end
        it "should render the :new template" do
            get :new
            expect(response).to render_template :new
        end
    end

    describe 'GET #edit' do
        let(:senior_rep) { create(:senior_rep) }

        it "should assign the requested user to @member" do
            get :edit , id: senior_rep.id
            expect(assigns(:member)).to eq senior_rep
        end
        it "should render the :edit template" do
            get :edit, id: senior_rep.id
            expect(response).to render_template :edit
        end
    end

    describe "POST #create" do
        let!(:package) { create(:silver_package) }

        context "with valid attributes" do
            it "should save the new user in the database" do
                expect {
                    post :create, user: attributes_for(:junior_rep, package_id: package.id)
                }.to change(User, :count).by(1)
            end
            it "should redirect to members#view"  do
                post :create, user: attributes_for(:junior_rep, package_id: package.id)
                expect(response).to redirect_to view_admin_members_url
            end
        end
        context "with invalid attributes" do
            it "should not save the new user in the database" do
                expect {
                    post :create, user: attributes_for(:invalid_user)
                }.to_not change(User, :count)
            end
            it "should re-render the :new template" do
                post :create, user: attributes_for(:invalid_user)
                expect(response).to render_template :new
            end
        end 
    end

    describe 'PUT #update' do
        let!(:package) { create(:silver_package) }
        let!(:junior_rep) { create(:junior_rep, name: 'Tom Dallimore', package_id: package.id) }

        context "with valid attributes" do
            it "should locate the requested @member" do
                patch :update, id: junior_rep.id, user: attributes_for(:junior_rep)
                expect(assigns(:member)).to eq(junior_rep)
            end
            it "should update the user in the database" do
                patch :update, id: junior_rep.id, user: attributes_for(:junior_rep, name: 'Bill Bailey')
                junior_rep.reload
                expect(junior_rep.name).to eq('Bill Bailey')
            end
            it "should redirect to the members#view" do
                patch :update, id: junior_rep.id, user: attributes_for(:junior_rep)
                expect(response).to redirect_to view_admin_members_url
            end
        end
        context "with invalid attributes" do 
            it "should not update the user" do
                patch :update, id: junior_rep.id, user: attributes_for(:junior_rep, email: nil)
                junior_rep.reload
                expect(junior_rep.name).to eq('Tom Dallimore')
            end
            it "should re-render the #edit template" do
                patch :update, id: junior_rep.id, user: attributes_for(:junior_rep, email: nil)
                expect(response).to render_template :edit
            end
        end 
    end

    describe 'DELETE #destroy' do
        let!(:junior_rep) { create(:junior_rep) }
        let(:package) { create(:package) }
        let!(:member) { create(:member, package: package) }

        context "if the user is a rep or an admin" do

            it "should mark their status as suspended" do
                expect{
                    delete :destroy, id: junior_rep.id
                }.to change{
                    junior_rep.reload
                    junior_rep.status
                }.from('active').to('suspended')
            end
        
            it "should not delete the user from the database"  do
                expect {
                    delete :destroy, id: junior_rep.id
                }.to change(User, :count).by(0)
            end
        end

        context "if the user is a member or lead" do

            it "should delete the user from the database"  do
                expect {
                    delete :destroy, id: member.id
                }.to change(User, :count).by(-1)
            end
        end

        it "should redirect to members#index" do
            delete :destroy, id: member.id
            expect(response).to redirect_to view_admin_members_url
        end
    end
end