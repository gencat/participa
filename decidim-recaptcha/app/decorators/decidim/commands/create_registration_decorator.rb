# frozen_string_literal: true

module Decidim::Commands::CreateRegistrationDecorator
  def self.decorate
    Decidim::CreateRegistration.class_eval do
      alias_method :original_create_user, :create_user

      def call
        if form.invalid?
          user = Decidim::User.has_pending_invitations?(form.current_organization.id, form.email)
          user.invite!(user.invited_by) if user
          return broadcast(:invalid)
        end

        # Recaptcha
        original_create_user
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
    end
  end
end

Decidim::Commands::CreateRegistrationDecorator.decorate
