class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("shared.account_activation")
  end

  def password_reset
    @greeting = t("shared.greeting")

    mail to: "to@example.org"
  end
end
