# frozen_string_literal: true

# Next tasks are necessary to be executed when deployed
# because there are some custom categorizations to be removed
# and leave it as Decidim standards
namespace :move_custom_categorizations do
  desc "Move Deparments to Areas"
  task departments_to_areas: [:environment] do
    class DecidimDepartment < ApplicationRecord
      self.table_name = :decidim_departments
    end

    ActiveRecord::Base.transaction do
      Decidim::Organization.find_each do |organization|
        area_type = Decidim::AreaType.find_or_create_by(
          name: localized(organization.available_locales, "area_type.departments.name"),
          plural: localized(organization.available_locales, "area_type.departments.plural"),
          organization: organization
        )
        puts "---AreaType created - #{area_type.id} - #{area_type.name}"

        DecidimDepartment.where(decidim_organization_id: organization.id).each do |department|
          area = Decidim::Area.find_or_create_by(
            name: organization.available_locales.map { |l| [l, "#{department.name}"] }.to_h,
            area_type: area_type,
            organization: organization,
          )
          puts "---Area created - #{area.id} - #{area.name}"
        end
      end
    end
  end

  desc "Move types to scopes"
  task types_to_scopes: [:environment] do
    class DecidimType < ApplicationRecord
      self.table_name = :decidim_types
    end

    class DecidimTheme < ApplicationRecord
      self.table_name = :decidim_themes
    end

    ActiveRecord::Base.transaction do
      Decidim::Organization.find_each do |organization|
        scope_type = Decidim::ScopeType.find_or_create_by(
          name: localized(organization.available_locales, "scope_type.regulations.name"),
          plural: localized(organization.available_locales, "scope_type.regulations.plural"),
          organization: organization
        )
        puts "---ScopeType created - #{scope_type.id} - #{scope_type.name}"

        parent_scope = Decidim::Scope.find_or_create_by(
          name: localized(organization.available_locales, "parent_scope.types.name"),
          code: "tipus",
          organization: organization
        )

        DecidimType.where(decidim_organization_id: organization.id).each do |type|
          scope = Decidim::Scope.find_or_create_by(
            name: type.name,
            code: type.name[organization.default_locale].parameterize,
            scope_type: scope_type,
            parent_id: parent_scope.id,
            organization: organization,
          )
          puts "---Scope created - #{scope.id} - #{scope.name}"

          scope_type = Decidim::ScopeType.find_or_create_by(
            name: localized(organization.available_locales, type.name),
            plural: localized(organization.available_locales, type.name),
            organization: organization
          )
          puts "---ScopeType created - #{scope_type.id} - #{scope_type.name}"

          DecidimTheme.where(decidim_organization_id: organization.id).each do |t|
            scope_child = Decidim::Scope.find_or_create_by(
              name: t.name,
              code: "#{type.name[organization.default_locale].parameterize}-#{t.name[organization.default_locale].parameterize}",
              organization: organization,
              scope_type: scope_type,
              parent_id: scope.id,
            )

            puts "ScopeChild created #{scope_child.id} - #{scope_child.name}"
          end
        end
      end
    end
  end

  desc "Move themes to scopes"
  task themes_to_scopes: [:environment] do
    class DecidimTheme < ApplicationRecord
      self.table_name = :decidim_themes
    end

    ActiveRecord::Base.transaction do
      Decidim::Organization.find_each do |organization|
        scope_type = Decidim::ScopeType.find_or_create_by(
          name: localized(organization.available_locales, "scope_type.themes.name"),
          plural: localized(organization.available_locales, "scope_type.themes.plural"),
          organization: organization
        )
        puts "---ScopeType created - #{scope_type.id} - #{scope_type.name}"

        parent_scope = Decidim::Scope.find_or_create_by(
          name: localized(organization.available_locales, "parent_scope.themes.name"),
          code: "temes",
          organization: organization
        )

        puts "+++++ ScopeParent Created #{parent_scope.id} - #{parent_scope.name}"

        DecidimTheme.where(decidim_organization_id: organization.id).each do |t|
          scope = Decidim::Scope.find_or_create_by(
            name: t.name,
            code: "tema-#{t.name[organization.default_locale].parameterize}",
            organization: organization,
            scope_type: scope_type,
            parent_id: parent_scope.id,
          )

          puts "ScopeChild created #{scope.id} - #{scope.name}"
        end
      end
    end
  end

  desc "Assign scopes to ParticipatoryProcesses"
  task assign_scopes_to_participatory_processes: [:environment] do
    class DecidimType < ApplicationRecord
      self.table_name = :decidim_types
    end

    class DecidimTheme < ApplicationRecord
      self.table_name = :decidim_themes
    end

    Decidim::Organization.find_each do |organization|
      Decidim::ParticipatoryProcess.where(organization: organization).find_each do |process|
        if process.decidim_type_id.present?
          next unless process.decidim_theme_id.present?
          parent_scope = Decidim::Scope.find_by(code: "#{DecidimType.find_by(id: process.decidim_type_id).name[organization.default_locale].parameterize}")
          scope_child = parent_scope.children.find_by(code: "#{parent_scope.code}-#{DecidimTheme.find_by(id: process.decidim_theme_id).name[organization.default_locale].parameterize}")
          process.update_attributes(scopes_enabled: true, scope: scope_child)
          puts "--- Process #{process.id} - Scope_id Updated #{scope_child.id}"
        else
          next unless process.decidim_theme_id.present?
          scope = Decidim::Scope.find_by(code: "tema-#{DecidimTheme.find_by(id: process.decidim_theme_id).name[organization.default_locale].parameterize}")
          process.update_attributes(scopes_enabled: true, scope: scope)
          puts "--- Process #{process.id} - Scope_id Updated #{scope.id}"
        end
      end
    end
  end

  desc "Assign Areas to ParticipatoryProcesses"
  task assign_areas_to_participatory_processes: [:environment] do
    class DecidimDepartment < ApplicationRecord
      self.table_name = :decidim_departments
    end

    ActiveRecord::Base.transaction do
      Decidim::Organization.find_each do |organization|
        Decidim::ParticipatoryProcess.where(organization: organization).find_each do |process|
          next unless process.decidim_department_id.present?
          puts "-------------"
          puts "#{process.as_json}"
          puts "#{process.decidim_department_id}"
          puts "-------------"
          area = Decidim::Area.find_by("name->>'ca' = ?", "#{DecidimDepartment.find_by(id: process.decidim_department_id).name}")
          process.update_attributes(area: area)
          puts "--- Process #{process.id} - Area id Updated #{area.id}"
        end
      end
    end
  end

  desc 'Move all custom categorizations and assign the new relations'
  task all: [:departments_to_areas, :types_to_scopes, :themes_to_scopes, :assign_scopes_to_participatory_processes, :assign_areas_to_participatory_processes ]

  def localized locales, key
    locales.inject({}) do |result, locale|
      I18n.locale = locale
      text = I18n.t(key) do
        yield
      end

      result.update(locale => text)
    end.with_indifferent_access
  end
end
