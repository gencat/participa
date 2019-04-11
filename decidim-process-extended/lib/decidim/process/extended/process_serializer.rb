# frozen_string_literal: true

module Decidim
  module Process
    module Extended
      # This class serializes a ParticipatoryProcess so can be exported
      # to CSV, JSON or other formats (check Decidim::Exporters)
      class ProcessSerializer < Decidim::Exporters::Serializer
        # Public: Initializes the serializer with a ParticipatoryProcess.
        def initialize(process)
          @process = process
        end

        # Public: Returns a hash with the serialized data.
        def serialize
          {
            # Process Information
            id: process.id,
            title_ca: process.title['ca'],
            slug: process.slug,
            short_description_ca: process.short_description['ca'],
            process_type: process_type,
            scope_id: process.scope&.id,
            scope_name_ca: process.scope&.name.try(:[], 'ca'),
            department_id: process.area&.id,
            department_name_ca: process.area&.name.try(:[], 'ca'),
            participatory_space: process.participatory_process_group&.name.try(:[], 'ca')&.downcase,
            normative_type_id: process.scope&.scope_type&.id,
            normative_type_name_ca: process.scope&.name.try(:[], 'ca'),
            duration_days: duration_days,
            start_date: process.start_date,
            end_date: process.end_date,
            cost: process.cost,
            has_record: process.has_summary_record,
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
            proposals_num_proposals: proposals_no_meeting.except_withdrawn.count,
            # Related Resources: Meetings
            meetings_num_participants: meetings_num_participants,
            meetings_num_entities: meetings_num_entities,
            total_num_meetings: meetings.count,
            meetings_num_proposals: proposals.where(created_in_meeting: true).count,
            # Related Resources: Debates
            debates_num_debates: debates.count,
            # Related Resources: Assemblies
            has_related_assembly: assembly.present?,
            related_assembly_name_ca: assembly&.title.try(:[], 'ca')
          }
        end

        private

        attr_reader :process

        def process_type
          types = []
          types << :virtual if proposals.count.positive?
          types << :presencial if meetings.count.positive?
          types.size > 1 ? :ambdos : types.first
        end

        def duration_days
          return unless process.start_date.present? && process.end_date.present?

          (process.start_date...process.end_date).count
        end

        def component(component_name)
          process.components.find_by(manifest_name: component_name)
        end

        def proposals
          @proposals ||= Decidim::Proposals::Proposal
                         .where(component: component('proposals'))
                         .published
                         .not_hidden
        end

        def meetings
          @meetings ||= Decidim::Meetings::Meeting.where(component: component('meetings'))
        end

        def debates
          @debates ||= Decidim::Debates::Debate.where(component: component('debates'))
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

          delimiters = [',', ' i ', "\r\n", "\r", "\n"]
          regex = Regexp.union(delimiters)
          split_string = proc { |m| m.attending_organizations.split(regex) }
          @meetings_num_entities ||= closed_meetings
                                     .map(&split_string)
                                     .flatten
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

        def assembly
          @assembly ||= process.linked_participatory_space_resources(
            :assemblies,
            'included_participatory_processes'
          ).first
        end
      end
    end
  end
end
