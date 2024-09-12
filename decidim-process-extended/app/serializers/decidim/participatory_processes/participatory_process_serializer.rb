# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    # This class serializes a ParticipatoryProcess so can be exported
    # to CSV, JSON or other formats (check Decidim::Exporters)
    class ParticipatoryProcessSerializer < Decidim::Exporters::Serializer
      ATTENDING_ORGANIZATIONS_SEPARATOR_REGEXP= Regexp.union([",", ";", " i ", "\r\n", "\r", "\n"])

      include Decidim::TranslationsHelper

      # Public: Initializes the serializer with a ParticipatoryProcess.
      def initialize(process)
        super
        @process = process
      end

      # Public: Returns a hash with the serialized data.
      # rubocop:disable Metrics/PerceivedComplexity
      # rubocop:disable Metrics/CyclomaticComplexity
      def serialize
        {
          # Process Information
          id: process.id,
          socrata_published_at: Date.current,
          title_ca: process.title["ca"],
          subtitle: process.subtitle,
          url: url,
          slug: process.slug,
          process_type: process_type,
          description: process.description,
          short_description: process.short_description,
          promoted: process.promoted,
          developer_group: process.developer_group,
          local_area: process.local_area,
          target: process.target,
          participatory_scope: process.participatory_scope,
          participatory_structure: process.participatory_structure,
          meta_scope: process.meta_scope,
          announcement: process.announcement,
          private_space: process.private_space,
          scopes_enabled: process.scopes_enabled,
          show_metrics: process.show_metrics,
          show_statistics: process.show_statistics,
          scope: {
            id: process.scope.try(:id),
            name: process.scope.try(:name) || empty_translatable
          },
          scope_id: process.scope&.id,
          scope_name_ca: process.scope&.name.try(:[], "ca"),
          department_id: process.area&.id,
          department_name_ca: process.area&.name.try(:[], "ca"),
          participatory_process_group: {
            id: process.participatory_process_group&.try(:id),
            title: process.participatory_process_group.try(:title) || empty_translatable,
            description: process.participatory_process_group.try(:description) || empty_translatable,
            remote_hero_image_url: Decidim::ParticipatoryProcesses::ParticipatoryProcessGroupPresenter.new(process.participatory_process_group).hero_image_url
          },
          participatory_process_type: {
            id: process.participatory_process_type.try(:id),
            title: process.participatory_process_type.try(:title) || empty_translatable
          },
          duration_days: duration_days,
          start_date: process.start_date,
          end_date: process.end_date,
          cost: process.cost,
          has_record: process.has_summary_record?,
          facilitators: process.facilitators,
          promoting_unit: process.promoting_unit,
          total_num_participants: meetings_num_participants + proposals_num_authors,
          total_num_entities: meetings_num_entities + proposals_num_entities,
          # Related Resources: Proposals
          proposals_num_authors: proposals_num_authors,
          proposals_num_author_entities: proposals_num_entities,
          total_num_proposals: proposals.count,
          total_accepted_proposals: proposals.accepted.count,
          total_rejected_proposals: proposals.rejected.count,
          total_evaluating_proposals: proposals.evaluating.count,
          proposals_num_proposals: proposals_no_meeting.count,
          # Related Resources: Meetings
          meetings_num_participants: meetings_num_participants,
          meetings_num_entities: meetings_num_entities,
          total_num_meetings: meetings.count,
          meetings_num_proposals: proposals.where(created_in_meeting: true).count,
          # Related Resources: Debates
          debates_num_debates: debates.count,
          # Related Resources: Assemblies
          has_related_assembly: related_assembly.present?,
          related_assembly_name_ca: related_assembly&.title.try(:[], "ca"),
          attachments: {
            attachment_collections: serialize_attachment_collections,
            files: serialize_attachments
          }
        }
      end
      # rubocop:enable Metrics/PerceivedComplexity
      # rubocop:enable Metrics/CyclomaticComplexity

      private

      attr_reader :process

      def serialize_attachment_collections
        return unless process.attachment_collections.any?

        process.attachment_collections.map do |collection|
          {
            id: collection.try(:id),
            name: collection.try(:name),
            weight: collection.try(:weight),
            description: collection.try(:description)
          }
        end
      end

      def serialize_attachments
        return unless process.attachments.any?

        process.attachments.map do |attachment|
          {
            id: attachment.try(:id),
            title: attachment.try(:title),
            weight: attachment.try(:weight),
            description: attachment.try(:description),
            attachment_collection: {
              name: attachment.attachment_collection.try(:name),
              weight: attachment.attachment_collection.try(:weight),
              description: attachment.attachment_collection.try(:description)
            },
            remote_file_url: Decidim::AttachmentPresenter.new(attachment).attachment_file_url
          }
        end
      end

      def url
        Decidim::ResourceLocatorPresenter.new(process).url&.split("?")&.first
      end

      def process_type
        meetings.count.positive? ? :ambdos : :virtual
      end

      def duration_days
        return unless process.start_date.present? && process.end_date.present?

        (process.end_date - process.start_date).to_i
      end

      def component(component_name)
        process.components.find_by(manifest_name: component_name)
      end

      def proposals
        @proposals ||= Decidim::Proposals::Proposal
                       .where(component: component("proposals"))
                       .joins(:coauthorships)
                       .where.not(
                         decidim_coauthorships: {
                           decidim_author_type: "Decidim::Organization"
                         }
                       ).published.not_hidden.except_withdrawn
      end

      def meetings
        @meetings ||= Decidim::Meetings::Meeting.where(component: component("meetings"))
      end

      def debates
        @debates ||= Decidim::Debates::Debate.where(component: component("debates"))
      end

      def closed_meetings
        @closed_meetings ||= meetings.where.not(closed_at: nil)
      end

      def meetings_num_participants
        return 0 if closed_meetings.blank?

        @meetings_num_participants ||= closed_meetings
                                       .map(&:attendees_count)
                                       .flatten.sum
      end

      def meetings_num_entities
        return 0 if closed_meetings.blank?

        split_string = proc { |m| m.attending_organizations&.split(ATTENDING_ORGANIZATIONS_SEPARATOR_REGEXP) }
        @meetings_num_entities ||= closed_meetings
                                   .map(&split_string)
                                   .flatten.compact
                                   .map(&:strip)
                                   .uniq.count
      end

      def proposals_no_meeting
        @proposals_no_meeting ||= proposals.where(created_in_meeting: false)
      end

      def proposals_num_authors
        return 0 if proposals_no_meeting.blank?

        no_user_group = proc { |p| p.creator.user_group.nil? }
        author_ids = proc { |p| p.coauthorships.pluck(:decidim_author_id) }
        @proposals_num_authors ||= proposals_no_meeting
                                   .select(&no_user_group)
                                   .map(&author_ids)
                                   .flatten.uniq.count
      end

      def proposals_num_entities
        return 0 if proposals_no_meeting.blank?

        @proposals_num_entities ||= proposals_no_meeting
                                    .map(&:user_group_ids)
                                    .flatten.uniq.count
      end

      def related_assembly
        @related_assembly ||= process.linked_participatory_space_resources(
          :assemblies,
          "included_participatory_processes"
        ).first
      end
    end
  end
end
