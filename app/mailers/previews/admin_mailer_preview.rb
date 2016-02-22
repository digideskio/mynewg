class AdminMailerPreview < ActionMailer::Preview

    def failed_recurring_payment
        set_user
        set_billing_notification
        AdminMailer.failed_recurring_payment(@user, @notification)
    end

    private

    def set_user
        @user ||= User.member.first
    end

    def set_billing_notification
        @notification ||= BillingNotification.active.first
    end
end
