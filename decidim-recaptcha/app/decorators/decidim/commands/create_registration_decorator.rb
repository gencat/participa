# frozen_string_literal: true

Decidim::CreateRegistration.class_eval do
  def call
    if form.invalid?
      user = Decidim::User.has_pending_invitations?(form.current_organization.id, form.email)
      user.invite!(user.invited_by) if user
      return broadcast(:invalid)
    end

    # Recaptcha
    create_user
    recaptcha_valid = verify_recaptcha(model: @user, action: "registration", minimum_score: 0.9)

    if recaptcha_valid
      if @user.save
        broadcast(:ok, @user)
      else
        broadcast(:invalid)
      end
    else
      @form.errors.add(:recaptcha, t("recaptcha.errors.recaptcha_unreachable"))
      broadcast(:invalid)
    end
    # Recaptcha
  rescue ActiveRecord::RecordInvalid
    broadcast(:invalid)
  end

  private

  def create_user
    @user = Decidim::User.new(
      email: form.email,
      name: form.name,
      nickname: form.nickname,
      password: form.password,
      password_confirmation: form.password_confirmation,
      organization: form.current_organization,
      tos_agreement: form.tos_agreement,
      newsletter_notifications_at: form.newsletter_at,
      email_on_notification: true,
      accepted_tos_version: form.current_organization.tos_version,
      locale: form.current_locale
    )
  end
end
