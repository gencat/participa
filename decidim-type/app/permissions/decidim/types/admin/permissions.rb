module Decidim
  module Types
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          unless user&.admin?
            disallow!
            return permission_action
          end

          return permission_action if permission_action.scope != :admin
          return permission_action if permission_action.subject != :type

          

          if user.admin?
            allow!
          end
          
          return permission_action
        end

        private

        def type
          @type ||= context.fetch(:type, nil)
        end
      end
    end
  end
end
