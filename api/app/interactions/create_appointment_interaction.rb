class CreateAppointmentInteraction < Interaction
    include AppointmentSerializer
    attr_reader :appointment

    def init
        create_appointment
    end

    def as_json opts = {}
        {
            appointment: serialize_appointment(appointment)
        }
    end

    private

    def create_appointment
        @appointment = current_user.create_appointment(appointment_params)
        raise ActiveRecord::RecordInvalid.new(@appointment) unless @appointment.valid?
    end

    def appointment_params
        params.require(:appointment).permit(:scheduled_time)
    end
end