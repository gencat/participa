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
        DecidimDepartment.where(decidim_organization_id: organization.id).each do |department|
          area = Decidim::Area.find_or_create_by(
            name: organization.available_locales.map { |l| [l, department.name.to_s] }.to_h,
            organization: organization
          )
          puts "---Area created - #{area.id} - #{area.name}"
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
        DecidimTheme.where(decidim_organization_id: organization.id).each do |t|
          scope = Decidim::Scope.find_or_create_by(
            name: t.name,
            code: "tema-#{t.name[organization.default_locale].parameterize}",
            organization: organization
          )

          puts "ScopeChild created #{scope.id} - #{scope.name}"
        end
      end
    end
  end

  desc "Assign scopes to ParticipatoryProcesses"
  task assign_scopes_to_participatory_processes: [:environment] do
    class DecidimTheme < ApplicationRecord
      self.table_name = :decidim_themes
    end

    Decidim::Organization.find_each do |organization|
      Decidim::ParticipatoryProcess.where(organization: organization).find_each do |process|
        next if process.decidim_theme_id.blank?
        next unless DecidimTheme.any?

        scope = Decidim::Scope.find_by(code: "tema-#{DecidimTheme.find_by(id: process.decidim_theme_id).name[organization.default_locale].parameterize}")
        process.update(scopes_enabled: true, scope: scope)
        puts "--- Process #{process.id} - Scope_id Updated #{scope.id}"
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
          next if process.decidim_department_id.blank?
          next unless DecidimDepartment.any?

          area = Decidim::Area.find_by("name->>'ca' = ?", DecidimDepartment.find_by(id: process.decidim_department_id).name.to_s)
          process.update(area: area)
          puts "--- Process #{process.id} - Area id Updated #{area.id}"
        end
      end
    end
  end

  desc "Move all custom categorizations and assign the new relations"
  task all: [:departments_to_areas, :themes_to_scopes, :assign_scopes_to_participatory_processes, :assign_areas_to_participatory_processes]

  def localized(locales, key)
    locales.inject({}) do |result, locale|
      I18n.locale = locale
      text = I18n.t(key) do
        yield
      end

      result.update(locale => text)
    end.with_indifferent_access
  end
end
