# frozen_string_literal: true

namespace :decidim do
  namespace :socrata do
    desc "Generates the Open Data export files for each organization."
    task publish_processes: :environment do
      org= Decidim::Organization.first
      Rails.logger.info "Publishing processes to Socrata: "
      rows= []
      Decidim::ParticipatoryProcess.where(organization: org).find_each do |process|
        Rails.logger.info "- [#{process.id}] #{process.title[:ca]}"
        row_hash= produce_row_from_process(process)
        rows << row_hash
      end

      puts "----------------------------------------------"
      csv= CSV.generate(headers: true) do |csv|
        csv << rows.first.keys

        rows.each do |fields|
          csv << fields.values
        end
      end
      puts csv

      Rails.logger.info "\ndone."
    end

    def produce_row_from_process(process)
      duration= if process.start_date.present? && process.end_date.present?
        (process.end_date - process.start_date).days
      end
      # dao= ProcessSocrataDao.new(process)
      h= {
        id: process.id,
        title_ca: process.title['ca'],
        slug: process.slug,
        # TODO aclarir si promoting unit és l'scope per tema amb gencat
        promoting_unit_id: 0,# TODO dao.promoting_unit_id, 
        promoting_unit_name_ca: 'TODO promoting_unit_name_ca',
        # TODO we need to be upgraded to 0.18 in order for processes to have areas
        department_id: 0, # area id
        department_name_ca: 'TODO department_name_ca', # area name
        # TODO depends upon "Migració de categoritzacions a estàndards Decidim"
        is_normative: true, # TODO
        normative_type_id: 0,
        normative_type_name_ca: 'TODO normative_type_name_ca',
        short_description_ca: process.description['ca'],
        duration_days: duration,
        start_date: process.start_date,
        end_date: process.end_date,
        cost: 100000, # TODO create new field in participa
        facilitators: "The name of the facilitators", # TODO create new field in participa
        num_participants: 10000, # TODO
        total_num_entities: 75, # meetings_num_entities + proposals_num_entities
        total_num_proposals: num_proposals(process),
        accepted_proposals_ratio: 30, # TODO READY*****
        process_type: process_type(process),
        num_meetings: num_meetings(process),
        meetings_num_participants: 999, # TODO READY*****
        meetings_num_entities: 25, # TODO READY*****
        meetings_num_proposals: 12345, # TODO READY*****
        proposals_num_participants: 9999, # TODO READY*****
        proposals_num_entities: 50, # TODO READY*****
        proposals_num_proposals: 1234567890, # TODO READY*****
        has_record: true,
        has_assembly: true,
        assembly_name_ca: "Consell republicà",
      }

      h
    end

    #------------------------------------
    private
    #------------------------------------

    def num_proposals(process)
      @num_proposals||= Decidim::Proposals::Proposal.published.not_hidden.joins(:component).where('decidim_components.participatory_space_id' => process.id).count
    end
    def num_meetings(process)
      @num_meetings||= Decidim::Meetings::Meeting.visible.joins(:component).where('decidim_components.participatory_space_id' => process.id).count
    end
    def process_type(process)
      types= []
      types << :virtual if num_proposals(process) > 0
      types << :presencial if num_meetings(process) > 0
      (types.size > 1) ? :ambdos : types.first
    end
  end
end
