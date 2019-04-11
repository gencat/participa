# frozen_string_literal: true

namespace :socrata do
  desc "Generates a file with the organization processes metadata."
  # Can be called with the following arguments:
  # - format - The exporter format as a string. i.e "JSON"
  # - filename - The file name as a string. i.e "this_is_my_filename"
  #
  # Examples (no space between arguments):
  # - rake socrata:export_processes_metadata["JSON"]
  # - rake socrata:export_processes_metadata["JSON","this_is_my_filename"]
  task :export_processes_metadata, [:format, :name] => :environment do |_task, args|
    file_format = args[:format] || default_format
    file_name = args[:name] || default_name

    export_data = Decidim::Exporters.find_exporter(file_format).new(collection, serializer).export
    file_name = export_data.filename(file_name)

    File.write(file_name, export_data.read)
  end

  private

  def default_format
    "CSV"
  end

  def default_name
    "socrata_processes_metadata"
  end

  def collection
    Decidim::ParticipatoryProcess.where(
      organization: Decidim::Organization.first
    )
  end

  def serializer
    Decidim::Process::Extended::ProcessSerializer
  end
end
