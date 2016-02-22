class Api::V1::EventsController < Api::ApplicationController

    def index
        respond_with_interaction EventsLoadingInteraction
    end

    def show
        respond_with_interaction EventLoadingInteraction
    end

    def attendees
        respond_with_interaction EventAttendeesLoadingInteraction
    end

    def join
        respond_with_interaction JoinEventInteraction
    end

    def unjoin
        respond_with_interaction UnjoinEventInteraction
    end

    def invite
        respond_with_interaction EventInviteInteraction
    end
end