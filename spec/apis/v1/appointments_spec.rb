# require "rails_helper"

# describe "Appointments API", type: :api do
#   disable_omise

#   describe "POST /v1/appointments" do
#     subject { json(last_response) }

#     let(:user) { create(:lead) }
#     let(:scheduled_time) { 1.hour.from_now.utc }

#     it "creates an appointment for the user" do
#       login_as user

#       expect {
#         post "http://api.example.com/v1/appointments.json", {appointment: { scheduled_time: scheduled_time }}
#       }.to change(Appointment, :count).by(1)

#       is_expected.to match({
#         "appointment" => {
#           "uid" => an_instance_of(Fixnum),
#           "user_id" => user.id,
#           "scheduled_time" => scheduled_time.to_s
#         }
#       })
#     end

#     it "responds with an error when time is in the past" do
#       login_as user

#       expect {
#         post "http://api.example.com/v1/appointments.json", {appointment: { scheduled_time: 1.hour.ago }}
#       }.to change(Appointment, :count).by(0)

#       is_expected.to match({
#         "errors" => an_instance_of(String)
#       })
#     end

#     it "responds with an error when time is invalid" do
#       login_as user

#       expect {
#         post "http://api.example.com/v1/appointments.json", {appointment: { scheduled_time: "someday" }}
#       }.to change(Appointment, :count).by(0)

#       is_expected.to match({
#         "errors" => an_instance_of(String)
#       })
#     end
#   end
# end
