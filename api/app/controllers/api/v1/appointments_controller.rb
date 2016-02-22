class Api::V1::AppointmentsController < Api::ApplicationController

    def create
        respond_with_interaction CreateAppointmentInteraction
    end
end