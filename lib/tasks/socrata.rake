# frozen_string_literal: true

namespace :decidim do
  namespace :socrata do
    desc "Generates the Open Data export files for each organization."
    task publish_processes: :environment do
      org= Decidim::Organization.first
      Rails.logger.info "Publishing processes to Socrata: "
      puts "["
      Decidim::ParticipatoryProcess.where(organization: org).find_each do |process|
        Rails.logger.info "- [#{process.id}] #{process.title[:ca]}"
        row= produce_row_from_process(process)
        puts "#{row},"
      end
      puts "]"
      Rails.logger.info "\ndone."
    end

    def produce_row_from_process(process)
      duration= if process.start_date.present? && process.end_date.present?
        (process.end_date - process.start_date).days
      end
      h= {
        id: process.id,
        title_ca: process.title['ca'],
        title_es: process.title['es'],
        title_oc: process.title['oc'],
        slug: process.slug,
        promoting_unit_id: 0,
        promoting_unit_name_ca: 'TODO promoting_unit_name_ca',
        promoting_unit_name_es: 'TODO promoting_unit_name_es',
        promoting_unit_name_oc: 'TODO promoting_unit_name_oc',
        department_id: 0,
        department_name_ca: 'TODO department_name_ca',
        department_name_es: 'TODO department_name_es',
        department_name_oc: 'TODO department_name_oc',
        is_normative: true,
        normative_type_id: 0,
        normative_type_name_ca: 'TODO normative_type_name_ca',
        normative_type_name_es: 'TODO normative_type_name_es',
        normative_type_name_oc: 'TODO normative_type_name_oc',
        description_ca: process.description['ca'],
        description_es: process.description['es'],
        description_oc: process.description['oc'],
        duration_days: duration,
        start_date: process.start_date,
        end_date: process.end_date,
        cost: 100000,
        facilitators: "The name of the facilitators",
        num_participants: 10000,
        num_entities: 75,
        num_proposals: 500,
        accepted_proposals_ratio: 30,
        process_type: "TODO",
        num_meetings: 130,
        meetings_num_participants: 999,
        meetings_num_entities: 25,
        meetings_num_contributions: 12345,
        num_debates: 200,
        debates_num_participants: 9999,
        debates_num_entities: 50,
        debates_num_contributions:1234567890,
        has_record: true,
        has_assembly: true,
        assembly_name_ca: "Consell republicà",
        assembly_name_es: "Consejo republicano",
        assembly_name_oc: "Consel republicà",
      }

      h
    end
  end
end
