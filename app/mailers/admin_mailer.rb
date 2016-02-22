class AdminMailer < ApplicationMailer


    def failed_recurring_payment user, notification
        @user = user
        @notification = notification

        mail(
            to: 'tom.alan.dallimore@googlemail.com',
            subject: "Recurring payment failed to process for #{@user.name}"
        )
    end
end