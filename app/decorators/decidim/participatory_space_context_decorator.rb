# frozen_string_literal: true

Decidim::ParticipatorySpaceContext.class_eval do
  # Method for current user can visit the space (assembly or proces)
  def current_user_can_visit_space?
    return true unless current_participatory_space.try(:private_space?) &&
                       !current_participatory_space.try(:is_transparent?)
    return false unless current_user

    current_user.admin ||
    current_participatory_space.users.include?(current_user) ||
    current_participatory_space.participatory_space_private_users.where(decidim_user_id: current_user.id).exists?
  end
end
