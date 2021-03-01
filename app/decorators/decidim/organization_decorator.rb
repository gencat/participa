# frozen_string_literal: true

Decidim::Organization.class_eval do
  # This association is an override to Decidim::Organization.users_with_any_role
  has_many :users_with_any_role, -> { where.not(roles: []).or(where('"decidim_users"."id" in (select "decidim_participatory_process_user_roles"."decidim_user_id" from "decidim_participatory_process_user_roles")' +
    ' or "decidim_users"."id" in (select "decidim_assembly_user_roles"."decidim_user_id" from "decidim_assembly_user_roles")')) }, foreign_key: "decidim_organization_id", class_name: "Decidim::User"
end
