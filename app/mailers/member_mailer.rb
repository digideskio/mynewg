class MemberMailer < ApplicationMailer

  def activate user
    @user = user

    mail(
      to: @user.email,
      subject: "Your account is now active #{@user.name}!"
    )
  end

  def failed_recurring_payment notification
    @user = notification.user
    @price = notification.package_price
    @notification = notification

    mail(
      to: @user.email,
      subject: "Your recurring payment failed to process"
    )
  end

  def package_purchase user
    @user = user

    mail(
      to: @user.email,
      subject: "You've purchased the #{@user.package.name} package!"
    )
  end

  def cash_payment_reminder user
    @user = user

    mail(
      to: @user.email,
      subject: "Cash amount on your account is not enough. Please, contact your representative."
    )
  end
end