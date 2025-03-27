# frozen_string_literal: true

module Decidim::ParticipatoryProcesses::PermissionsDecorator
  def self.decorate
    Decidim::ParticipatoryProcesses::Permissions.class_eval do
      # To allow invited private space users to access public view
      def can_view_private_space?
        return true unless process.private_space
        return false unless user

        user.admin ||
          process.users.include?(user) ||
          process.participatory_space_private_users.exists?(decidim_user_id: user.id)
      end
    end
  end
end

Decidim::ParticipatoryProcesses::PermissionsDecorator.decorate
