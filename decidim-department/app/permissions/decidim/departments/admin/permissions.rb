module Decidim
  module Departments
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          return permission_action if permission_action.scope != :admin
          return permission_action if permission_action.subject != :department

          case permission_action.action
          when :read
            permission_action.allow!
          when :create
            permission_action.allow!
          when :update, :destroy
            permission_action.allow! if department.present?
          end

          permission_action
        end

        private

        def department
          @department ||= context.fetch(:department, nil)
        end
      end
    end
  end
end
