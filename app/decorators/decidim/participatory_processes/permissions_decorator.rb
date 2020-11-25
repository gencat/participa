# frozen_string_literal: true

Decidim::ParticipatoryProcesses::Permissions.class_eval do
  # To allow invited private space users to acces public view
  def can_view_private_space?
    return true unless process.private_space
    return false unless user

    user.admin ||
    process.users.include?(user) ||
    (process.participatory_space_private_users.pluck :decidim_user_id).include?(user.id)
  end
end
