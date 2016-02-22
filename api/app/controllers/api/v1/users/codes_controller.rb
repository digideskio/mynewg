class Api::V1::Users::CodesController < Api::ApplicationController
    skip_before_action :authenticate_user!

    def validate
        respond_with_interaction ValidateRepresentativeCodeInteraction
    end

    def assign
        respond_with_interaction AssignRepresentativeCodeInteraction
    end
end
