# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      # A form object used to create participatory processes from the admin
      # dashboard.
      #
      class ParticipatoryProcessForm < Form
        include TranslatableAttributes

        mimic :participatory_process

        translatable_attribute :announcement, String
        translatable_attribute :description, String
        translatable_attribute :developer_group, String
        translatable_attribute :local_area, String
        translatable_attribute :meta_scope, String
        translatable_attribute :participatory_scope, String
        translatable_attribute :participatory_structure, String
        translatable_attribute :subtitle, String
        translatable_attribute :short_description, String
        translatable_attribute :title, String
        translatable_attribute :target, String

        attribute :facilitators, String
        attribute :hashtag, String
        attribute :promoting_unit, String
        attribute :slug, String

        attribute :area_id, Integer
        attribute :cost, Float
        attribute :participatory_process_group_id, Integer
        attribute :scope_id, Integer

        attribute :has_summary_record, Boolean
        attribute :private_space, Boolean
        attribute :promoted, Boolean
        attribute :scopes_enabled, Boolean
        attribute :show_statistics, Boolean

        attribute :end_date, Decidim::Attributes::LocalizedDate
        attribute :start_date, Decidim::Attributes::LocalizedDate

        attribute :banner_image
        attribute :hero_image
        attribute :remove_banner_image
        attribute :remove_hero_image

        # Participa added attributes
        attribute :type_id, Integer
        attribute :email, String
        attribute :show_home, Boolean

        validates :area, presence: true, if: proc { |object| object.area_id.present? }
        validates :scope, presence: true, if: proc { |object| object.scope_id.present? }
        validates :type, presence: true, if: proc { |object| object.type_id.present? }
        validates :slug, presence: true, format: { with: Decidim::ParticipatoryProcess.slug_format }

        validate :slug_uniqueness

        validates :title, :subtitle, :description, :short_description, translatable_presence: true

        validates :banner_image,
                  file_size: { less_than_or_equal_to: ->(_record) { Decidim.maximum_attachment_size } },
                  file_content_type: { allow: ["image/jpeg", "image/png"] }
        validates :hero_image,
                  file_size: { less_than_or_equal_to: ->(_record) { Decidim.maximum_attachment_size } },
                  file_content_type: { allow: ["image/jpeg", "image/png"] }

        # after_save :example_function
        def map_model(model)
          self.scope_id = model.decidim_scope_id
          self.participatory_process_group_id = model.decidim_participatory_process_group_id
          self.type_id = model.decidim_type_id
        end

        def scope
          @scope ||= current_organization.scopes.find_by(id: scope_id)
        end

        def area
          @area ||= current_organization.areas.find_by(id: area_id)
        end

        def type
          @type ||= current_organization.types.find_by(id: type_id)
        end

        def participatory_process_group
          Decidim::ParticipatoryProcessGroup.find_by(id: participatory_process_group_id)
        end

        private

        def organization_participatory_processes
          OrganizationParticipatoryProcesses.new(current_organization).query
        end

        def slug_uniqueness
          return unless organization_participatory_processes
                        .where(slug: slug)
                        .where.not(id: context[:process_id])
                        .any?

          errors.add(:slug, :taken)
        end
      end
    end
  end
end
