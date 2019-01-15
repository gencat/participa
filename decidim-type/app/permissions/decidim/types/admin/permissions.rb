module Decidim
  module Types
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          return permission_action if permission_action.scope != :admin
          return permission_action if permission_action.subject != :type

          case permission_action.action
          when :read
            permission_action.allow!
          when :create
            permission_action.allow!
          when :update, :destroy
            permission_action.allow! if type.present?
          end

          permission_action
        end

        private

        def type
          @type ||= context.fetch(:type, nil)
        end
      end
    end
  end
end
