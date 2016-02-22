class Api::V1::Users::EventsController < Api::ApplicationController

    def index
        respond_with_interaction UserEventsLoadingInteraction
    end
end