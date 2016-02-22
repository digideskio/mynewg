class MemberMailerPreview < ActionMailer::Preview

    def activate
        set_user
        MemberMailer.activate(@user)
    end

    def failed_recurring_payment
        set_user
        set_billing_notification
        MemberMailer.failed_recurring_payment(@user, @notification)
    end

    def package_purchase
        set_user
        MemberMailer.package_purchase(@user)
    end

    private

    def set_user
        @user ||= User.member.first
    end

    def set_billing_notification
        @notification ||= BillingNotification.active.first
    end
end
