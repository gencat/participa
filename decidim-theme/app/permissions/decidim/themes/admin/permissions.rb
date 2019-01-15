module Decidim
  module Themes
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          return permission_action if permission_action.scope != :admin
          return permission_action if permission_action.subject != :theme

          case permission_action.action
          when :read
            permission_action.allow!
          when :create
            permission_action.allow!
          when :update, :destroy
            permission_action.allow! if theme.present?
          end

          permission_action
        end

        private

        def theme
          @theme ||= context.fetch(:theme, nil)
        end
      end
    end
  end
end
