# frozen_string_literal: true

module Decidim::ParticipatorySpaceContextDecorator
  def self.decorate
    Decidim::ParticipatorySpaceContext.class_eval do
      # Method for current user can visit the space (assembly or proces)
      def current_user_can_visit_space?
        return true unless current_participatory_space.try(:private_space?) &&
                           !current_participatory_space.try(:is_transparent?)
        return false unless current_user

        current_user.admin ||
          current_participatory_space.users.include?(current_user) ||
          current_participatory_space.participatory_space_private_users.exists?(decidim_user_id: current_user.id)
      end
    end
  end
end

Decidim::ParticipatorySpaceContextDecorator.decorate
