module HasAppointment
    extend ActiveSupport::Concern

    included do
        has_one :appointment,                                   dependent: :destroy

        accepts_nested_attributes_for :appointment
    end
end
