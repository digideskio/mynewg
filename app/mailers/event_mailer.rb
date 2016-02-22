class EventMailer < ApplicationMailer

    def reminder user, event
        @user = user
        @event = event

        mail(
            to: @user.email,
            subject: "MyNewG Event Reninder: #{@event.name}"
        )
    end
end