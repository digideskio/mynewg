class Api::V1::Users::NotificationsController < Api::ApplicationController

    def index
        respond_with_interaction NotificationsLoadingInteraction
    end 

    def read
        respond_with_interaction ReadNotificationInteraction
    end
end